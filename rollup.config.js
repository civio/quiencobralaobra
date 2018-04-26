import node from "rollup-plugin-node-resolve";

export default {
  input: "rollup-entry.js",
  plugins: [node()],
  output: {
    format: "umd",
    name: "d3",
    file: "app/assets/javascripts/dist/d3-bundle"
  }
};