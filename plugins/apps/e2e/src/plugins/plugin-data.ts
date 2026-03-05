export default function () {
  const rectangle = penjar.createRectangle();

  rectangle?.setPluginData('testData', 'test');
  return rectangle?.getPluginData('testData');
}
