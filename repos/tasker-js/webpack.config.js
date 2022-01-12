module.exports = {
   devtool: 'inline-source-map',
   entry: './src/main.ts',
   output: {
      filename: 'bundle.js',
      path: `${__dirname}/dist`,
   },
   resolve: {
      extensions: ['.ts', '.js']
   },
   module: {
      rules: [
         { test: /\.ts?$/, loader: 'awesome-typescript-loader' },
      ],
   },
   plugins: [
   ]
};