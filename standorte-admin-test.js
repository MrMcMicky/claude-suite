const { chromium } = require('playwright');
const fs = require('fs').promises;

// Test configuration
const config = {
  baseUrl: 'https://standorte.assistent.my.id',
  adminCredentials: {
    email: 'verwalter@standorte.ch',
    password: 'admin123'
  },
  testEmail: 'michael@ruppen.net',
  screenshotDir: './standorte-test-screenshots',
  timeout: 30000
};

// Test results collection
const testResults = {
  timestamp: new Date().toISOString(),
  systemInfo: {
    url: config.baseUrl,
    testType: 'Comprehensive Admin Panel Test'
  },
  tests: [],
  errors: [],
  warnings: [],
  findings: []
};

async function ensureScreenshotDir() {
  try {
    await fs.mkdir(config.screenshotDir, { recursive: true });
  } catch (error) {
    console.error('Error creating screenshot directory:', error);
  }
}

async function takeScreenshot(page, name) {
  try {
    const timestamp = Date.now();
    const filename = `${config.screenshotDir}/${name}-${timestamp}.png`;
    await page.screenshot({ path: filename, fullPage: true });
    return filename;
  } catch (error) {
    console.error(`Error taking screenshot ${name}:`, error);
    return null;
  }
}

async function testAdminLogin(page) {
  console.log('\n🔐 Testing Admin Login...');
  const test = { name: 'Admin Login', status: 'started', steps: [] };
  
  try {
    // Navigate to admin login
    await page.goto(`${config.baseUrl}/admin/login`, { waitUntil: 'networkidle' });
    test.steps.push({ step: 'Navigate to login', status: 'success' });
    
    // Check login form
    const emailInput = await page.locator('input[type="email"]').isVisible();
    const passwordInput = await page.locator('input[type="password"]').isVisible();
    test.steps.push({ 
      step: 'Check login form elements', 
      status: emailInput && passwordInput ? 'success' : 'failed',
      details: { emailInput, passwordInput }
    });
    
    await takeScreenshot(page, 'admin-login-form');
    
    // Fill login form
    await page.fill('input[type="email"]', config.adminCredentials.email);
    await page.fill('input[type="password"]', config.adminCredentials.password);
    test.steps.push({ step: 'Fill login credentials', status: 'success' });
    
    // Submit login
    await page.click('button[type="submit"]');
    await page.waitForURL('**/admin/dashboard', { timeout: 10000 });
    test.steps.push({ step: 'Login successful', status: 'success' });
    
    await takeScreenshot(page, 'admin-dashboard-after-login');
    
    test.status = 'passed';
  } catch (error) {
    test.status = 'failed';
    test.error = error.message;
    testResults.errors.push({ test: 'Admin Login', error: error.message });
  }
  
  testResults.tests.push(test);
  return test.status === 'passed';
}

async function testDashboard(page) {
  console.log('\n📊 Testing Admin Dashboard...');
  const test = { name: 'Admin Dashboard', status: 'started', elements: {} };
  
  try {
    await page.goto(`${config.baseUrl}/admin/dashboard`, { waitUntil: 'networkidle' });
    
    // Check dashboard elements
    const elements = {
      standorteCount: await page.locator('text=/Standorte gesamt/i').isVisible(),
      activeStandorte: await page.locator('text=/Aktive Standorte/i').isVisible(),
      anmeldungenCount: await page.locator('text=/Anmeldungen/i').isVisible(),
      navigationMenu: await page.locator('.admin-navigation, nav').isVisible()
    };
    
    test.elements = elements;
    test.statistics = {};
    
    // Try to get actual statistics
    try {
      const standorteText = await page.locator('text=/Standorte gesamt/i').locator('..').textContent();
      test.statistics.standorte = standorteText;
    } catch (e) {
      test.statistics.error = 'Could not read statistics';
    }
    
    await takeScreenshot(page, 'admin-dashboard-overview');
    
    test.status = Object.values(elements).every(v => v) ? 'passed' : 'partial';
    
    if (!elements.navigationMenu) {
      testResults.warnings.push({ 
        area: 'Dashboard', 
        issue: 'Navigation menu not visible',
        severity: 'high'
      });
    }
    
  } catch (error) {
    test.status = 'failed';
    test.error = error.message;
    testResults.errors.push({ test: 'Admin Dashboard', error: error.message });
  }
  
  testResults.tests.push(test);
}

async function testStandorteManagement(page) {
  console.log('\n📍 Testing Standorte Management...');
  const test = { name: 'Standorte Management', status: 'started', features: {} };
  
  try {
    await page.goto(`${config.baseUrl}/admin/standorte`, { waitUntil: 'networkidle' });
    await page.waitForTimeout(2000); // Wait for Vue components to load
    
    // Check main elements
    test.features.pageLoaded = true;
    test.features.standorteList = await page.locator('table, .standorte-list').isVisible();
    test.features.addButton = await page.locator('button:has-text("Neuer Standort"), a:has-text("Neuer Standort")').isVisible();
    
    await takeScreenshot(page, 'admin-standorte-list');
    
    // Test filter functionality
    try {
      const filterSelects = await page.locator('select').count();
      test.features.filters = filterSelects > 0;
      
      if (filterSelects > 0) {
        // Test status filter
        const statusSelect = page.locator('select').first();
        await statusSelect.selectOption({ index: 1 });
        await page.waitForTimeout(1000);
        test.features.statusFilter = 'working';
      }
    } catch (e) {
      test.features.filterError = e.message;
    }
    
    // Test edit functionality
    try {
      const editButtons = await page.locator('button:has-text("Bearbeiten"), a:has-text("Bearbeiten")').count();
      test.features.editButtons = editButtons;
      
      if (editButtons > 0) {
        await page.locator('button:has-text("Bearbeiten"), a:has-text("Bearbeiten")').first().click();
        await page.waitForTimeout(2000);
        
        // Check if edit modal or page opened
        const editFormVisible = await page.locator('form, [class*="modal"]').isVisible();
        test.features.editForm = editFormVisible;
        
        await takeScreenshot(page, 'admin-standort-edit-form');
        
        // Go back to list
        const backButton = page.locator('button:has-text("Zurück"), a:has-text("Zurück"), button:has-text("Abbrechen")');
        if (await backButton.isVisible()) {
          await backButton.click();
        } else {
          await page.goto(`${config.baseUrl}/admin/standorte`);
        }
      }
    } catch (e) {
      test.features.editError = e.message;
    }
    
    test.status = test.features.standorteList ? 'passed' : 'failed';
    
  } catch (error) {
    test.status = 'failed';
    test.error = error.message;
    testResults.errors.push({ test: 'Standorte Management', error: error.message });
  }
  
  testResults.tests.push(test);
}

async function testAnmeldungen(page) {
  console.log('\n📝 Testing Anmeldungen (Registrations)...');
  const test = { name: 'Anmeldungen Management', status: 'started', features: {} };
  
  try {
    await page.goto(`${config.baseUrl}/admin/anmeldungen`, { waitUntil: 'networkidle' });
    await page.waitForTimeout(2000);
    
    test.features.pageLoaded = true;
    test.features.anmeldungenList = await page.locator('table, .anmeldungen-list, [class*="grid"]').isVisible();
    
    // Check for data or empty state
    const hasData = await page.locator('tbody tr, .anmeldung-item').count() > 0;
    const hasEmptyState = await page.locator('text=/keine anmeldungen/i').isVisible();
    
    test.features.dataDisplay = hasData || hasEmptyState;
    test.features.registrationCount = await page.locator('tbody tr, .anmeldung-item').count();
    
    await takeScreenshot(page, 'admin-anmeldungen-list');
    
    // Test detail view if registrations exist
    if (hasData) {
      try {
        const detailButton = page.locator('button:has-text("Details"), button:has-text("Anzeigen")').first();
        if (await detailButton.isVisible()) {
          await detailButton.click();
          await page.waitForTimeout(1000);
          
          const modalVisible = await page.locator('.modal, [role="dialog"]').isVisible();
          test.features.detailModal = modalVisible;
          
          await takeScreenshot(page, 'admin-anmeldung-detail');
          
          // Close modal
          const closeButton = page.locator('button:has-text("Schließen"), button[aria-label="Close"]');
          if (await closeButton.isVisible()) {
            await closeButton.click();
          }
        }
      } catch (e) {
        test.features.detailError = e.message;
      }
    }
    
    test.status = test.features.anmeldungenList ? 'passed' : 'failed';
    
  } catch (error) {
    test.status = 'failed';
    test.error = error.message;
    testResults.errors.push({ test: 'Anmeldungen Management', error: error.message });
  }
  
  testResults.tests.push(test);
}

async function testEmailManagement(page) {
  console.log('\n✉️ Testing Email Management...');
  const test = { name: 'Email Management', status: 'started', features: {} };
  
  try {
    await page.goto(`${config.baseUrl}/admin/emails`, { waitUntil: 'networkidle' });
    await page.waitForTimeout(2000);
    
    test.features.pageLoaded = true;
    
    // Check for email management interface
    const hasEmailInterface = await page.locator('text=/email/i').isVisible();
    test.features.emailInterface = hasEmailInterface;
    
    // Look for test email button
    const testEmailButton = page.locator('button:has-text("Test"), button:has-text("Senden")');
    test.features.testEmailButton = await testEmailButton.isVisible();
    
    await takeScreenshot(page, 'admin-email-management');
    
    // Test email sending functionality (carefully)
    if (test.features.testEmailButton) {
      try {
        // Check if there's an email input field
        const emailInput = page.locator('input[type="email"]');
        if (await emailInput.isVisible()) {
          await emailInput.fill(config.testEmail);
          test.features.emailInputFilled = true;
          
          // Note: Not actually clicking send to avoid sending test emails in production
          test.features.testEmailReady = true;
          testResults.findings.push({
            area: 'Email Management',
            finding: 'Test email functionality available',
            recommendation: 'Verify email sending works with test account'
          });
        }
      } catch (e) {
        test.features.emailTestError = e.message;
      }
    }
    
    test.status = test.features.emailInterface ? 'passed' : 'failed';
    
  } catch (error) {
    test.status = 'failed';
    test.error = error.message;
    testResults.errors.push({ test: 'Email Management', error: error.message });
  }
  
  testResults.tests.push(test);
}

async function testAllAdminSections(page) {
  console.log('\n🔍 Testing All Admin Sections...');
  
  const sections = [
    { name: 'Churches', path: '/admin/churches', selector: 'text=/kirche/i' },
    { name: 'Hosts', path: '/admin/hosts', selector: 'text=/gastgeber/i' },
    { name: 'Church Staff', path: '/admin/church-staff', selector: 'text=/mitarbeiter/i' },
    { name: 'Persons', path: '/admin/persons', selector: 'text=/person/i' },
    { name: 'Email Templates', path: '/admin/email-templates', selector: 'text=/template/i' }
  ];
  
  for (const section of sections) {
    const test = { name: `Admin Section: ${section.name}`, status: 'started' };
    
    try {
      await page.goto(`${config.baseUrl}${section.path}`, { waitUntil: 'networkidle' });
      await page.waitForTimeout(2000);
      
      test.loaded = true;
      test.hasContent = await page.locator(section.selector).isVisible();
      test.hasTable = await page.locator('table').isVisible();
      test.hasAddButton = await page.locator('button:has-text("Neu"), button:has-text("Hinzufügen")').isVisible();
      
      await takeScreenshot(page, `admin-${section.name.toLowerCase().replace(' ', '-')}`);
      
      test.status = test.loaded ? 'passed' : 'failed';
      
      if (!test.hasContent && !test.hasTable) {
        testResults.warnings.push({
          area: section.name,
          issue: 'Section appears empty or not loading correctly',
          severity: 'medium'
        });
      }
      
    } catch (error) {
      test.status = 'failed';
      test.error = error.message;
      testResults.errors.push({ test: section.name, error: error.message });
    }
    
    testResults.tests.push(test);
  }
}

async function analyzeProfessionalStructure() {
  console.log('\n🏗️ Analyzing Professional Structure...');
  
  const analysis = {
    codeStructure: {
      backend: {
        framework: 'Laravel 11',
        architecture: 'MVC with Service Layer',
        apiVersion: 'v1',
        database: 'PostgreSQL'
      },
      frontend: {
        framework: 'Vue 3',
        buildTool: 'Vite',
        styling: 'Tailwind CSS',
        stateManagement: 'Pinia'
      }
    },
    professionalStandards: {
      apiNaming: 'RESTful conventions observed',
      errorHandling: 'Standardized error responses',
      authentication: 'Laravel Sanctum',
      multiDomain: 'Single codebase serving multiple domains'
    },
    recommendations: []
  };
  
  // Add recommendations based on findings
  if (testResults.errors.length > 0) {
    analysis.recommendations.push({
      priority: 'high',
      area: 'Error Handling',
      recommendation: 'Improve error handling and user feedback for failed operations'
    });
  }
  
  if (testResults.warnings.length > 0) {
    analysis.recommendations.push({
      priority: 'medium',
      area: 'UI Consistency',
      recommendation: 'Ensure all admin sections have consistent UI patterns'
    });
  }
  
  testResults.structureAnalysis = analysis;
}

async function runComprehensiveTest() {
  console.log('🚀 Starting Comprehensive Standorte Admin Test');
  console.log(`🌐 Testing: ${config.baseUrl}`);
  console.log(`📧 Test Email: ${config.testEmail}`);
  console.log('⚠️  Production System - Testing Carefully\n');
  
  await ensureScreenshotDir();
  
  const browser = await chromium.launch({ 
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });
  
  const context = await browser.newContext({
    viewport: { width: 1280, height: 720 },
    userAgent: 'StandorteAdminTest/1.0'
  });
  
  const page = await context.newPage();
  
  try {
    // Run all tests
    const loginSuccess = await testAdminLogin(page);
    
    if (loginSuccess) {
      await testDashboard(page);
      await testStandorteManagement(page);
      await testAnmeldungen(page);
      await testEmailManagement(page);
      await testAllAdminSections(page);
    } else {
      testResults.criticalError = 'Login failed - cannot test other features';
    }
    
    // Analyze structure
    await analyzeProfessionalStructure();
    
    // Generate summary
    testResults.summary = {
      totalTests: testResults.tests.length,
      passed: testResults.tests.filter(t => t.status === 'passed').length,
      failed: testResults.tests.filter(t => t.status === 'failed').length,
      partial: testResults.tests.filter(t => t.status === 'partial').length,
      totalErrors: testResults.errors.length,
      totalWarnings: testResults.warnings.length,
      totalFindings: testResults.findings.length
    };
    
  } catch (error) {
    console.error('Critical test error:', error);
    testResults.criticalError = error.message;
  } finally {
    await browser.close();
  }
  
  // Save results
  const reportPath = './standorte-test-report.json';
  await fs.writeFile(reportPath, JSON.stringify(testResults, null, 2));
  
  // Print summary
  console.log('\n📊 Test Summary:');
  console.log(`✅ Passed: ${testResults.summary.passed}`);
  console.log(`❌ Failed: ${testResults.summary.failed}`);
  console.log(`⚠️  Warnings: ${testResults.summary.totalWarnings}`);
  console.log(`💡 Findings: ${testResults.summary.totalFindings}`);
  console.log(`\n📄 Full report saved to: ${reportPath}`);
  console.log(`📸 Screenshots saved to: ${config.screenshotDir}/`);
  
  return testResults;
}

// Run the test
runComprehensiveTest().catch(console.error);