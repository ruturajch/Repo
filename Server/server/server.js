const express = require('express');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 3000;
const getPortfolioData = require('./routes/getPortfolioData')
const deleteWatchListData = require('./routes/deleteWatchListData')
const getStockTickerSuggestions = require('./routes/getStockTickerSuggestions')
const getStockDetailedInfo = require('./routes/getStockDetailedInfo')

app.use(cors());
app.use(express.json());

app.use(getPortfolioData)
app.use(deleteWatchListData)
app.use(getStockTickerSuggestions)
app.use(getStockDetailedInfo)

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
