import type { PluginMessageEvent, PluginUIEvent } from './model.js';

penjar.ui.open('FEATHER ICONS PLUGIN', `?theme=${penjar.theme}`, {
  width: 292,
  height: 540,
});

penjar.ui.onMessage<PluginUIEvent>((message) => {
  if (message.type === 'insert-icon') {
    const { name, svg } = message.content;

    if (!svg || !name) {
      return;
    }

    const icon = penjar.createShapeFromSvg(svg);
    if (icon) {
      icon.name = name;
      icon.x = penjar.viewport.center.x;
      icon.y = penjar.viewport.center.y;
    }
  }
});

penjar.on('themechange', (theme) => {
  sendMessage({ type: 'theme', content: theme });
});

function sendMessage(message: PluginMessageEvent) {
  penjar.ui.sendMessage(message);
}
