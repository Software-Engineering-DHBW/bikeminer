DROP TABLE IF EXISTS `Users`;
DROP TABLE IF EXISTS `History`;
CREATE TABLE `Users` (
  `userID` int(11) NOT NULL AUTO_INCREMENT,
  `userName` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `coins` float NOT NULL,
  PRIMARY KEY (`userID`),
  UNIQUE KEY `userName_UNIQUE` (`userName`),
  UNIQUE KEY `email_UNIQUE` (`email`)
);
CREATE TABLE `History` (
  `historyID` int(11) NOT NULL AUTO_INCREMENT,
  `userID` int(11) NOT NULL,
  `recievedCoins` float NOT NULL,
  `distanceTraveled` float NOT NULL,
  `dateTime` datetime NOT NULL,
  PRIMARY KEY (`historyID`),
  KEY `userID_idx` (`userID`),
  CONSTRAINT `userID` FOREIGN KEY (`userID`) REFERENCES `Users` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO `Users` VALUES (1,'testUser','password123','t@gmx.de',10.5);
INSERT INTO `History` VALUES (1,1,0.5,12000,'2022-03-11 15:25:00');
GRANT ALL PRIVILEGES ON *.* TO 'profi'@'%';
