ABI_RATESETTER= [{"inputs":[{"internalType":"address","name":"_owner","type":"address"},{"internalType":"address","name":"_cdpManager","type":"address"},{"internalType":"address","name":"_AbsPiController","type":"address"},{"internalType":"address","name":"_CPIController","type":"address"},{"internalType":"address","name":"_cpiDataFeed","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"RateSetter__NotActive","type":"error"},{"inputs":[],"name":"RateSetter__NotMarketTwapFeed","type":"error"},{"inputs":[],"name":"RateSetter__NotOwner","type":"error"},{"inputs":[],"name":"RateSetter__NotShutdownModule","type":"error"},{"inputs":[],"name":"RateSetter__UnknownContract","type":"error"},{"inputs":[],"name":"RateSetter__UnknownParameter","type":"error"},{"anonymous":False,"inputs":[{"indexed":True,"internalType":"bytes32","name":"_parameter","type":"bytes32"},{"indexed":False,"internalType":"address","name":"_value","type":"address"}],"name":"ModifyAddressParameter","type":"event"},{"anonymous":False,"inputs":[{"indexed":True,"internalType":"bytes32","name":"_contract","type":"bytes32"},{"indexed":False,"internalType":"address","name":"_newAddress","type":"address"}],"name":"ModifyContract","type":"event"},{"anonymous":False,"inputs":[{"indexed":True,"internalType":"bytes32","name":"_parameter","type":"bytes32"},{"indexed":False,"internalType":"uint256","name":"_data","type":"uint256"}],"name":"ModifyParameters","type":"event"},{"anonymous":False,"inputs":[{"indexed":False,"internalType":"uint256","name":"_marketPrice","type":"uint256"},{"indexed":False,"internalType":"uint256","name":"_redemptionPrice","type":"uint256"}],"name":"NewPrices","type":"event"},{"anonymous":False,"inputs":[{"indexed":False,"internalType":"uint256","name":"_value","type":"uint256"}],"name":"NewRedemptionRate","type":"event"},{"inputs":[],"name":"RAY","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"SECONDS_IN_A_YEAR","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getCpiData","outputs":[{"internalType":"uint256","name":"cpi","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"getRedemptionPrice","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getRedemptionRate","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getYearlyIntegralTerms","outputs":[{"internalType":"int256[]","name":"","type":"int256[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getYearlyProportionalTerms","outputs":[{"internalType":"int256[]","name":"","type":"int256[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getYearlyRedemptionRates","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"marketTwapFeedContractAddress","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_parameter","type":"bytes32"},{"internalType":"address","name":"_value","type":"address"}],"name":"modifyAddressParameter","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_contract","type":"bytes32"},{"internalType":"address","name":"_newAddress","type":"address"}],"name":"modifyContracts","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_parameter","type":"bytes32"},{"internalType":"uint256","name":"_data","type":"uint256"}],"name":"modifyParameters","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"x","type":"uint256"},{"internalType":"uint256","name":"y","type":"uint256"}],"name":"rmultiply","outputs":[{"internalType":"uint256","name":"z","type":"uint256"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"uint256","name":"x","type":"uint256"},{"internalType":"uint256","name":"n","type":"uint256"},{"internalType":"uint256","name":"base","type":"uint256"}],"name":"rpower","outputs":[{"internalType":"uint256","name":"z","type":"uint256"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"shutdown","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"shutdownModuleContractAddress","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_ethTwapPrice","type":"uint256"},{"internalType":"uint256","name":"_noiMarketPrice","type":"uint256"}],"name":"updatePrices","outputs":[],"stateMutability":"nonpayable","type":"function"}]
ADDRESS_RATESETTER= "0x9c65f85425c619A6cB6D29fF8d57ef696323d188"