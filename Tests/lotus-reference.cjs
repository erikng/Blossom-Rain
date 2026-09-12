// Execute the saved upstream calculator with a small DOM adapter. The expected
// results come from Lotus's JavaScript, not a second copy of the Swift formulas.
const fs = require('node:fs');
const vm = require('node:vm');
const recipes = JSON.parse(fs.readFileSync(process.argv[2], 'utf8')).recipes;
recipes.push(
  {rawValue: 'custom-default', name: 'Custom Recipe', ppm: [60, 30, 25, 15]},
  {rawValue: 'custom-zero', name: 'Custom Recipe', ppm: [0, 0, 0, 0]},
  {rawValue: 'custom-high', name: 'Custom Recipe', ppm: [150, 150, 150, 150]},
  {rawValue: 'custom-decimal', name: 'Custom Recipe', ppm: [40.2, 32.1, 8, 12.1]}
);
let active, unit, volume, round, results;
const keys = {ppmca: 0, ppmmg: 1, ppmk: 2, ppmna: 3};
const customKeys = {'#custom-ppmCa': 0, '#custom-ppmMg': 1, '#custom-ppmK': 2, '#custom-ppmNa': 3};
const chart = {data: {datasets: [{}]}, options: {scales: {x: {}, y: {}}}, update() {}};
const sandbox = {
  myChart: chart,
  jQuery(selector) {
    return {
      val() {
        if (selector === '#recipe') return active.name;
        if (selector in customKeys) return active.ppm[customKeys[selector]];
        if (selector === '.dropper-style input:checked') return round ? 'round' : 'straight';
        if (selector === '.units-row input[type="radio"]:checked') return unit;
        if (selector.endsWith('input[type="range"]')) return volume;
        throw new Error('Unexpected value selector: ' + selector);
      },
      data(key) { return key in keys ? active.ppm[keys[key]] : ''; },
      text(value) { results[selector] = value; return this; },
      html() { return this; }, attr() { return this; }, show() { return this; },
      hide() { return this; }, slideDown() { return this; }, slideUp() { return this; }
    };
  }
};
vm.createContext(sandbox);
vm.runInContext(fs.readFileSync(process.argv[3], 'utf8'), sandbox, {timeout: 1000});
const volumes = [
  ...Array.from({length: 1001}, (_, i) => ['milliliter', 'ml-range', i]),
  ...Array.from({length: 21}, (_, i) => ['liter', 'liter-range', i]),
  ...Array.from({length: 6}, (_, i) => ['gallon', 'gallon-range', i]),
  ['liter', 'liter-range', 0.375], ['liter', 'liter-range', 0.325],
  ['liter', 'liter-range', 0.75], ['gallon', 'gallon-range', 0.5],
  ['milliliter', 'ml-range', 3785], ['milliliter', 'ml-range', 4500]
];
const samples = [];
for (active of recipes) {
  for (const [swiftUnit, webUnit, v] of volumes) {
    unit = webUnit; volume = v;
    const outputs = [];
    for (round of [false, true]) {
      results = {};
      sandbox.calculate_values();
      const drops = ['calcium', 'magnesium', 'potassium', 'sodium'].map(
        m => results['.step1-results-wrap .results-list > div.' + m + ' .list-val']);
      const ions = ['ca', 'mg', 'k', 'na', 'cl', 'hco3'].map(
        ion => results['.ion-item.' + ion + ' .ion-val']);
      if (![...drops, ...ions].every(Number.isInteger)) throw new Error('Missing reference output');
      outputs.push({drops, ions, x: chart.data.datasets[0].data[0].x,
        y: chart.data.datasets[0].data[0].y, xMax: chart.options.scales.x.max, yMax: chart.options.scales.y.max});
    }
    // Check both uniform styles everywhere, and every mixed-bottle setting at
    // representative volumes. The app supports independent bottle styles.
    const masks = (v === 450 || v === 1) ? Array.from({length: 16}, (_, i) => i) : [0, 15];
    for (const mask of masks) {
      const roundStyles = [0, 1, 2, 3].map(i => Boolean(mask & (1 << i)));
      const drops = roundStyles.map((style, i) => outputs[Number(style)].drops[i]);
      samples.push({rawValue: active.rawValue, ppm: active.ppm, unit: swiftUnit,
        volume, roundStyles, ...outputs[0], drops});
    }
  }
}
process.stdout.write(JSON.stringify(samples));
