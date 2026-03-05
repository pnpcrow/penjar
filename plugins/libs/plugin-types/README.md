# Penjar plugin-types

The `@penjar/plugin-types` package provides TypeScript type definitions for the Penjar Plugin API, making it easier to develop plugins for the Penjar design platform with full type safety and IDE support. It streamlines the development process by ensuring that your code is well-typed and less prone to errors.

### Getting started

#### Installation

To add penjar's plugin-types to your project, use the following command:

```bash
npm install @penjar/plugin-types
```

#### Configuration

To ensure the typings work correctly in your project, update your tsconfig.json as follows:

```json
"typeRoots": [
  "./node_modules/@types",
  "./node_modules/@penjar"
],
"types": ["plugin-types"],
```

### Learn more

For more information on how to build plugins using the Penjar PLugin API, refer to the <a href="https://help.penjar.app/plugins/getting-started/" target="_blank">official documentation</a>. You can also explore practical examples in the <a href="https://github.com/penjar/penjar-plugins-samples" target="_blank">samples repository</a> to see real-world implementations.
