import { PluginMessageEvent } from './app/model';

penjar.ui.open('RENAME LAYER PLUGIN', `?theme=${penjar.theme}`, {
  width: 290,
  height: 550,
});

penjar.on('themechange', (theme) => {
  penjar.ui.sendMessage({ type: 'theme', content: theme });
});

penjar.on('shapechange', () => {
  resetSelection();
});

penjar.ui.onMessage<PluginMessageEvent>((message) => {
  if (message.type === 'ready') {
    resetSelection();
  } else if (message.type === 'replace-text') {
    const blockId = penjar.history.undoBlockBegin();

    const shapes = getShapes();
    const shapesToUpdate = shapes?.filter((shape) => {
      return shape.name.includes(message.content.search);
    });
    shapesToUpdate?.forEach((shape) => {
      shape.name = shape.name.replace(
        message.content.search,
        message.content.replace,
      );
    });
    updateReplaceTextPreview(message.content.search);

    penjar.history.undoBlockFinish(blockId);
  } else if (message.type === 'preview-replace-text') {
    updateReplaceTextPreview(message.content.search);
  } else if (message.type === 'add-text') {
    const blockId = penjar.history.undoBlockBegin();

    const currentNames = message.content.map((shape) => shape.current);
    const shapes = getShapes();
    const shapesToUpdate = shapes?.filter((shape) =>
      currentNames.includes(shape.name),
    );
    shapesToUpdate?.forEach((shape) => {
      const newText = message.content.find((it) => it.current === shape.name);
      return (shape.name = newText?.new ?? shape.name);
    });

    penjar.history.undoBlockFinish(blockId);

    resetSelection();
  }
});

function getShapes() {
  return penjar.selection.length
    ? penjar.selection
    : penjar.currentPage?.findShapes();
}

function resetSelection() {
  penjar.ui.sendMessage({
    type: 'selection',
    content: {
      selection: getShapes(),
    },
  });
}

function updateReplaceTextPreview(search: string) {
  if (search) {
    const shapes = getShapes();
    const shapesToUpdate = shapes?.filter((shape) => {
      return shape.name.includes(search);
    });
    penjar.ui.sendMessage({
      type: 'selection',
      content: {
        selection: shapesToUpdate,
      },
    });
  } else {
    resetSelection();
  }
}
