export default function () {
  function group() {
    const selected = penjar.selection;

    if (selected.length && !penjar.utils.types.isGroup(selected[0])) {
      return penjar.group(selected);
    }
  }

  function ungroup() {
    const selected = penjar.selection;

    if (selected.length && penjar.utils.types.isGroup(selected[0])) {
      return penjar.ungroup(selected[0]);
    }
  }

  const rectangle = penjar.createRectangle();
  rectangle.x = penjar.viewport.center.x;
  rectangle.y = penjar.viewport.center.y;
  const rectangle2 = penjar.createRectangle();
  rectangle2.x = penjar.viewport.center.x + 100;
  rectangle2.y = penjar.viewport.center.y + 100;

  penjar.selection = [rectangle, rectangle2];

  group();
  ungroup();
}
