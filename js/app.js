/**
 * DART Demo — Oracle APEX Edition (Vanilla JS)
 * Port of the React dart-demo for County of San Diego
 */
(function () {
  'use strict';

  /* ─── Static data ─────────────────────────────────────────────── */
  var DEMO_PASS = 'dart2026';

  var batchCategories = ['Deposit', 'Transfer', 'Reallocation'];

  var batchTypesByCategory = {
    Deposit: ['Swept Cash ZBA', 'Deposit Correction (Same-HOFI)', 'Deposit Correction (Cross-HOFI)'],
    Transfer: ['Interfund Transfer', 'Intrafund Transfer', 'Cash Transfer'],
    Reallocation: ['IA Reallocation', 'Project Reallocation', 'Fund Reallocation']
  };

  var organizations = [
    { code: 'AUD', label: 'AUD \u2014 Auditor & Controller' },
    { code: 'TES', label: 'TES \u2014 Treasurer-Tax Collector' },
    { code: 'HHS', label: 'HHS \u2014 Health & Human Services' },
    { code: 'DPW', label: 'DPW \u2014 Public Works' },
    { code: 'SHR', label: 'SHR \u2014 Sheriff' },
    { code: 'LIB', label: 'LIB \u2014 Library' },
    { code: 'PLN', label: 'PLN \u2014 Planning & Development' }
  ];

  var preparersByOrg = {
    AUD: ['Moana Wavecrest', 'Kai Tidemark', 'Leilani Shore'],
    TES: ['Levi Stream', 'Coral Banks', 'Marina Depth'],
    HHS: ['Ava Harbor', 'Reef Castillo', 'Isla Sandoval'],
    DPW: ['Duncan Bridger', 'Sierra Granite', 'Clay Asphalt'],
    SHR: ['Morgan Shield', 'Barrett Ironwood', 'Quinn Patrol'],
    LIB: ['Paige Turner', 'Dewey Bookend', 'Margot Shelf'],
    PLN: ['Skyler Blueprint', 'Mason Parcel', 'Zara Overlay']
  };

  var bankAccounts = [
    { name: 'County of SD Pooled Cash \u2014 Wells Fargo',     account: '4021-7789-0001', hofi: 'AUD' },
    { name: 'County of SD Pooled Cash \u2014 Bank of America', account: '6833-4420-0055', hofi: 'TES' },
    { name: 'County of SD Treasury ZBA \u2014 Chase',          account: '9102-5567-0032', hofi: 'TES' },
    { name: 'HHS Grant Deposits \u2014 US Bank',               account: '7714-0098-2210', hofi: 'HHS' },
    { name: 'Public Works Capital \u2014 Citibank',            account: '3308-6621-4477', hofi: 'DPW' }
  ];

  var batchStatuses  = ['Incomplete', 'Pending Review', 'Ready for Approval', 'Complete'];
  var workflowStates = ['Not Submitted', 'Submitted', 'Awaiting HOFI Approval', 'Awaiting A&C Approval', 'Approved', 'Rejected'];

  /* ─── Mock line data ──────────────────────────────────────────── */
  var glLines = [
    { id: 1, fund: '1010', budgetRef: '0000', dept: '15675', account: '47535', program: '0000', fundingSrc: '0000', project: '00000000', amount: 45000.00, description: 'State Public Health Reimbursement' },
    { id: 2, fund: '1010', budgetRef: '0000', dept: '14565', account: '47535', program: '1200', fundingSrc: '3100', project: '00000000', amount: 25000.00, description: 'Federal Housing Authority Grant' },
    { id: 3, fund: '6114', budgetRef: '0000', dept: '00000', account: '80100', program: '0000', fundingSrc: '2001', project: 'PRG10042', amount: 15000.00, description: 'Capital Improvement \u2014 Road Resurfacing' },
    { id: 4, fund: '1010', budgetRef: '2026', dept: '15675', account: '47200', program: '0000', fundingSrc: '0000', project: '00000000', amount: 22550.70, description: 'Permit Fee Collections \u2014 March' },
    { id: 5, fund: '2030', budgetRef: '2026', dept: '16890', account: '48100', program: '2100', fundingSrc: '3200', project: 'PRG20014', amount: 12000.00, description: 'Behavioral Health Services Revenue' }
  ];

  var pngLines = [
    { id: 1, project: 'PRG10042', task: '1.0', expenditureType: 'Contract Services', expenditureOrg: 'Public Works', contract: 'DPW-24-301', fundingSource: 'Dept of Public Works', amount: 8500.00, description: 'Road Resurfacing \u2014 Contract Labor Q4' },
    { id: 2, project: 'PRG20014', task: '2.0', expenditureType: 'Supplies', expenditureOrg: 'Behavioral Health', contract: 'HHS-20-101', fundingSource: 'Dept of Health & Human Services', amount: 3200.00, description: 'BHS Program Supplies' },
    { id: 3, project: 'PRG10042', task: '3.0', expenditureType: 'Equipment Rental', expenditureOrg: 'Public Works', contract: 'DPW-24-301', fundingSource: 'Dept of Public Works', amount: 6500.00, description: 'Road Resurfacing \u2014 Equipment Rental' }
  ];

  var arLines = [
    { id: 1, receiptNumber: 'AR-DART-000001-01', customer: 'State of California \u2014 DHCS',      amount: 45000.00, receiptDate: '2026-03-27', status: 'Applied',   dartBatch: 'DART-000001' },
    { id: 2, receiptNumber: 'AR-DART-000001-02', customer: 'US Dept of Housing & Urban Dev',        amount: 25000.00, receiptDate: '2026-03-27', status: 'Applied',   dartBatch: 'DART-000001' },
    { id: 3, receiptNumber: 'AR-DART-000001-03', customer: 'San Diego County Permits',              amount: 22550.70, receiptDate: '2026-03-27', status: 'Unapplied', dartBatch: 'DART-000001' }
  ];

  /* ─── Helpers ─────────────────────────────────────────────────── */
  function usd(n) {
    return n.toLocaleString('en-US', { style: 'currency', currency: 'USD' });
  }

  var glTotal  = glLines.reduce(function (s, l) { return s + l.amount; }, 0);
  var pngTotal = pngLines.reduce(function (s, l) { return s + l.amount; }, 0);
  var arTotal  = arLines.reduce(function (s, l) { return s + l.amount; }, 0);

  /* ─── State ───────────────────────────────────────────────────── */
  var state = {
    locked: false,
    activeTab: 'gl',
    batchCategory: 'Deposit',
    batchType: 'Swept Cash ZBA',
    batchName: 'AUDITMSCRT27MAR2026.DEMO',
    batchStatus: 'Incomplete',
    workflowStatus: 'Not Submitted',
    preparerOrganization: 'AUD',
    preparerName: 'Moana Wavecrest',
    preparerHOFI: 'AUD',
    createdDate: new Date().toISOString().split('T')[0],
    bankName: 'County of SD Pooled Cash \u2014 Wells Fargo',
    bankAccount: '4021-7789-0001',
    bankDate: '2026-03-27',
    bankReference: '0005794549XF',
    bankAmount: '119550.70'
  };

  var initialState = JSON.parse(JSON.stringify(state));

  /* ─── DOM helpers ─────────────────────────────────────────────── */
  function $(id) { return document.getElementById(id); }

  function populateSelect(el, items, valueProp, labelProp, selected) {
    el.innerHTML = '';
    items.forEach(function (item) {
      var opt = document.createElement('option');
      opt.value = typeof item === 'string' ? item : item[valueProp];
      opt.textContent = typeof item === 'string' ? item : item[labelProp];
      if (opt.value === selected) opt.selected = true;
      el.appendChild(opt);
    });
  }

  /* ─── Render functions ────────────────────────────────────────── */
  function renderSelects() {
    populateSelect($('batchCategory'), batchCategories, null, null, state.batchCategory);
    populateSelect($('batchType'), batchTypesByCategory[state.batchCategory] || [], null, null, state.batchType);
    populateSelect($('batchStatus'), batchStatuses, null, null, state.batchStatus);
    populateSelect($('workflowStatus'), workflowStates, null, null, state.workflowStatus);
    populateSelect($('preparerOrg'), organizations, 'code', 'label', state.preparerOrganization);
    populateSelect($('preparerName'), preparersByOrg[state.preparerOrganization] || [], null, null, state.preparerName);

    var matching = bankAccounts.filter(function (b) { return b.hofi === state.preparerHOFI; });
    var banks = matching.length > 0 ? matching : bankAccounts;
    var bankEl = $('bankName');
    bankEl.innerHTML = '';
    banks.forEach(function (b) {
      var opt = document.createElement('option');
      opt.value = b.name;
      opt.textContent = b.name + ' (' + b.hofi + ')';
      if (b.name === state.bankName) opt.selected = true;
      bankEl.appendChild(opt);
    });
  }

  function renderFields() {
    $('batchNameInput').value = state.batchName;
    $('preparerHOFI').value = state.preparerHOFI;
    $('bankAccount').value = state.bankAccount;
    $('bankDate').value = state.bankDate;
    $('bankReference').value = state.bankReference;
    $('bankAmount').value = usd(parseFloat(state.bankAmount) || 0);
  }

  function renderBanner() {
    $('bannerTitle').textContent = 'DART Deposit Batch #' + state.batchCategory.charAt(0) + '-000001';
    $('bannerBadge').textContent = state.batchStatus;
    $('bannerBadge').className = 'apex-badge ' + (state.batchStatus === 'Complete' ? 'apex-badge--success' : 'apex-badge--info');
    $('bannerPreparer').textContent = state.preparerName;
    $('bannerDate').textContent = state.createdDate;

    var now = new Date();
    $('bannerUpdated').textContent = 'Last updated ' +
      now.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }) + ', ' +
      now.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' });
  }

  function renderLockState() {
    var selects = document.querySelectorAll('#mainApp select');
    var inputs = document.querySelectorAll('#mainApp input:not([readonly])');
    selects.forEach(function (el) { el.disabled = state.locked; });
    inputs.forEach(function (el) {
      if (el.id !== 'bankAccount' && el.id !== 'bankAmount') {
        el.readOnly = state.locked;
      }
    });
    $('btnSave').textContent = state.locked ? 'Locked' : 'Save & Lock';
    $('btnSave').disabled = state.locked;
    $('btnCancel').disabled = state.locked;
    $('btnUnlock').style.display = state.locked ? '' : 'none';
  }

  function renderWarnings() {
    var mismatch = state.preparerHOFI !== state.preparerOrganization;
    var warn = $('hofiWarning');
    warn.style.display = (mismatch && !state.locked) ? '' : 'none';
    if (mismatch) {
      $('hofiWarningText').textContent = 'HOFI Mismatch \u2014 Preparer HOFI (' + state.preparerHOFI +
        ') does not match Organization (' + state.preparerOrganization +
        '). Cross-HOFI corrections require Owning HOFI authorization.';
    }
    var hint = $('bankHint');
    var matching = bankAccounts.filter(function (b) { return b.hofi === state.preparerHOFI; });
    hint.style.display = (matching.length > 0 && !state.locked) ? '' : 'none';
    $('bankHintText').textContent = 'Showing bank accounts where Owning HOFI matches preparer HOFI (' + state.preparerHOFI + ').';
  }

  function renderTable() {
    var glPanel  = $('glPanel');
    var pngPanel = $('pngPanel');
    var arPanel  = $('arPanel');
    glPanel.style.display  = state.activeTab === 'gl' ? '' : 'none';
    pngPanel.style.display = state.activeTab === 'png' ? '' : 'none';
    arPanel.style.display  = state.activeTab === 'ar' ? '' : 'none';

    document.querySelectorAll('.apex-tab-item').forEach(function (btn) {
      btn.classList.toggle('is-active', btn.dataset.tab === state.activeTab);
    });
  }

  function renderDonut() {
    var total = glTotal + pngTotal + arTotal;
    $('donutTotal').textContent = usd(total);
    var segments = [
      { label: 'GL Lines',    value: glTotal,  color: '#0572ce' },
      { label: 'PNG Lines',   value: pngTotal, color: '#0d7c66' },
      { label: 'AR Receipts', value: arTotal,  color: '#c74634' }
    ];
    var radius = 40, circumference = 2 * Math.PI * radius, offset = 0;
    var arcs = $('donutArcs');
    arcs.innerHTML = '';
    segments.forEach(function (seg) {
      var pct = (seg.value / total) * 100;
      var dash = (pct / 100) * circumference;
      var circle = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
      circle.setAttribute('cx', '50');
      circle.setAttribute('cy', '50');
      circle.setAttribute('r', '40');
      circle.setAttribute('fill', 'none');
      circle.setAttribute('stroke', seg.color);
      circle.setAttribute('stroke-width', '12');
      circle.setAttribute('stroke-dasharray', dash + ' ' + (circumference - dash));
      circle.setAttribute('stroke-dashoffset', -offset);
      circle.setAttribute('stroke-linecap', 'butt');
      circle.setAttribute('transform', 'rotate(-90 50 50)');
      circle.classList.add('apex-donut-arc');
      arcs.appendChild(circle);
      offset += dash;
    });

    var legend = $('chartLegend');
    legend.innerHTML = '';
    segments.forEach(function (seg) {
      var pct = ((seg.value / total) * 100).toFixed(1);
      legend.innerHTML +=
        '<div class="apex-legend-item">' +
          '<span class="apex-legend-swatch" style="background:' + seg.color + '"></span>' +
          '<div class="apex-legend-detail">' +
            '<span class="apex-legend-label">' + seg.label + '</span>' +
            '<span class="apex-legend-value">' + usd(seg.value) + '</span>' +
            '<span class="apex-legend-pct">' + pct + '%</span>' +
          '</div>' +
        '</div>';
    });
  }

  function buildTableBody(id, lines, cols) {
    var tbody = $(id);
    tbody.innerHTML = '';
    lines.forEach(function (l) {
      var tr = document.createElement('tr');
      cols.forEach(function (col) {
        var td = document.createElement('td');
        if (col.cls) td.className = col.cls;
        if (col.key === '_amount') {
          td.textContent = usd(l.amount);
        } else if (col.key === '_status') {
          var span = document.createElement('span');
          span.className = 'apex-status-tag ' + (l.status === 'Applied' ? 'applied' : 'unapplied');
          span.textContent = l.status;
          td.appendChild(span);
        } else {
          td.textContent = l[col.key];
        }
        tr.appendChild(td);
      });
      tbody.appendChild(tr);
    });
  }

  function buildAllTables() {
    buildTableBody('glBody', glLines, [
      { key: 'id' }, { key: 'fund' }, { key: 'budgetRef' }, { key: 'dept' },
      { key: 'account' }, { key: 'program' }, { key: 'fundingSrc' }, { key: 'project' },
      { key: '_amount', cls: 'apex-num' }, { key: 'description' }
    ]);
    $('glTotal').textContent = usd(glTotal);

    buildTableBody('pngBody', pngLines, [
      { key: 'id' }, { key: 'project' }, { key: 'task' }, { key: 'expenditureType' },
      { key: 'expenditureOrg' }, { key: 'contract' }, { key: 'fundingSource' },
      { key: '_amount', cls: 'apex-num' }, { key: 'description' }
    ]);
    $('pngTotal').textContent = usd(pngTotal);

    buildTableBody('arBody', arLines, [
      { key: 'id' }, { key: 'receiptNumber' }, { key: 'customer' },
      { key: '_amount', cls: 'apex-num' }, { key: 'receiptDate' },
      { key: '_status' }, { key: 'dartBatch' }
    ]);
    $('arTotal').textContent = usd(arTotal);
  }

  function renderAll() {
    renderSelects();
    renderFields();
    renderBanner();
    renderLockState();
    renderWarnings();
    renderTable();
  }

  /* ─── Event handlers ──────────────────────────────────────────── */
  function bindEvents() {
    /* Cascading selects */
    $('batchCategory').addEventListener('change', function () {
      if (state.locked) return;
      state.batchCategory = this.value;
      var types = batchTypesByCategory[this.value] || [];
      state.batchType = types[0] || '';
      renderAll();
    });
    $('batchType').addEventListener('change', function () {
      if (state.locked) return;
      state.batchType = this.value;
    });
    $('batchStatus').addEventListener('change', function () {
      if (state.locked) return;
      state.batchStatus = this.value;
      renderBanner();
    });
    $('workflowStatus').addEventListener('change', function () {
      if (state.locked) return;
      state.workflowStatus = this.value;
    });
    $('batchNameInput').addEventListener('input', function () {
      if (state.locked) return;
      state.batchName = this.value;
    });
    $('preparerOrg').addEventListener('change', function () {
      if (state.locked) return;
      state.preparerOrganization = this.value;
      state.preparerHOFI = this.value;
      var preps = preparersByOrg[this.value] || [];
      state.preparerName = preps[0] || '';
      renderAll();
    });
    $('preparerName').addEventListener('change', function () {
      if (state.locked) return;
      state.preparerName = this.value;
      renderBanner();
    });
    $('preparerHOFI').addEventListener('input', function () {
      if (state.locked) return;
      state.preparerHOFI = this.value;
      renderAll();
    });
    $('bankName').addEventListener('change', function () {
      state.bankName = this.value;
      var bank = bankAccounts.find(function (b) { return b.name === state.bankName; });
      if (bank) state.bankAccount = bank.account;
      renderFields();
    });
    $('bankDate').addEventListener('change', function () {
      if (state.locked) return;
      state.bankDate = this.value;
    });
    $('bankReference').addEventListener('input', function () {
      if (state.locked) return;
      state.bankReference = this.value;
    });

    /* Action buttons */
    $('btnSave').addEventListener('click', function () {
      state.locked = true;
      state.batchStatus = 'Complete';
      state.workflowStatus = 'Submitted';
      renderAll();
      var toast = $('lockToast');
      toast.style.display = '';
      setTimeout(function () { toast.style.display = 'none'; }, 4000);
    });
    $('btnUnlock').addEventListener('click', function () {
      state.locked = false;
      state.batchStatus = 'Incomplete';
      state.workflowStatus = 'Not Submitted';
      renderAll();
    });
    $('btnCancel').addEventListener('click', function () {
      Object.assign(state, JSON.parse(JSON.stringify(initialState)));
      renderAll();
    });

    /* Tabs */
    document.querySelectorAll('.apex-tab-item').forEach(function (btn) {
      btn.addEventListener('click', function () {
        state.activeTab = this.dataset.tab;
        renderTable();
      });
    });

    /* Sidebar toggle */
    $('sidebarToggle').addEventListener('click', function () {
      document.querySelector('.apex-layout').classList.toggle('sidebar-collapsed');
    });

    /* Sidebar nav items */
    document.querySelectorAll('.apex-nav-item').forEach(function (item) {
      item.addEventListener('click', function () {
        document.querySelectorAll('.apex-nav-item').forEach(function (i) { i.classList.remove('is-active'); });
        this.classList.add('is-active');
      });
    });
  }

  /* ─── Login gate ──────────────────────────────────────────────── */
  function initLogin() {
    var gate = $('loginGate');
    var app  = $('mainApp');

    if (sessionStorage.getItem('dart-auth') === '1') {
      gate.style.display = 'none';
      app.style.display  = '';
      initApp();
      return;
    }

    gate.style.display = '';
    app.style.display  = 'none';

    $('loginForm').addEventListener('submit', function (e) {
      e.preventDefault();
      var inp = $('pwInput');
      var err = $('pwError');
      if (inp.value === DEMO_PASS) {
        sessionStorage.setItem('dart-auth', '1');
        gate.style.display = 'none';
        app.style.display  = '';
        initApp();
      } else {
        err.style.display = '';
        inp.value = '';
        inp.focus();
        inp.addEventListener('input', function onInput() {
          err.style.display = 'none';
          inp.removeEventListener('input', onInput);
        });
      }
    });
  }

  function initApp() {
    renderAll();
    renderDonut();
    buildAllTables();
    bindEvents();
  }

  /* ─── Boot ── */
  document.addEventListener('DOMContentLoaded', initLogin);
})();
