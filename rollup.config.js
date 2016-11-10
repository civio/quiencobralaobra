import node from "rollup-plugin-node-resolve";

export default {
  entry: "rollup-entry.js",
  format: "umd",
  moduleName: "d3",
  plugins: [node()],
  dest: "app/assets/javascripts/dist/d3-bundle"
};