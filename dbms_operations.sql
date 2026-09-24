-- MySQL 8.0+ implementation for the two USER datasets.
-- Before running the LOAD DATA statements, save each Excel USER sheet as CSV:
--   USER_Table p02.csv
--   USER_Table_Filtered p02.csv
-- Enable LOCAL INFILE if your client requires it.

-- Run this as an administrator if LOCAL INFILE is disabled on the server.
SET GLOBAL local_infile = 1;

CREATE DATABASE IF NOT EXISTS abhinav_dbms;
USE abhinav_dbms;

DROP VIEW IF EXISTS vw_user_directory;
DROP VIEW IF EXISTS vw_email_domains;
DROP TRIGGER IF EXISTS trg_data4_contact_update;
DROP PROCEDURE IF EXISTS sp_normalize_users;
DROP PROCEDURE IF EXISTS sp_users_by_domain;
DROP TABLE IF EXISTS user_audit;
DROP TABLE IF EXISTS data5;
DROP TABLE IF EXISTS data4;
DROP TABLE IF EXISTS data3;
DROP TABLE IF EXISTS data2;
DROP TABLE IF EXISTS data1;

-- data1: original dataset.
CREATE TABLE data1 (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    user_password VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    UNIQUE KEY uq_data1_email (email)
);

-- data2: filtered dataset.
CREATE TABLE data2 LIKE data1;

TRUNCATE TABLE data1;
TRUNCATE TABLE data2;

-- Original dataset: USER_Table p02.xlsx
INSERT INTO data1 (user_id, user_name, email, user_password, phone) VALUES
(1,'Aarav Gupta','aarav1@yahoo.com','pass1001','9616888343'),
(2,'Isha Sharma','isha2@yahoo.com','pass1002','9887401819'),
(3,'Abhinav Joshi','abhinav3@outlook.com','pass1003','9322009580'),
(4,'Arjun Joshi','arjun4@yahoo.com','pass1004','9556631948'),
(5,'Karan Patel','karan5@gmail.com','pass1005','9618632357'),
(6,'Neha Patel','neha6@outlook.com','pass1006','9786905213'),
(7,'Sneha Verma','sneha7@outlook.com','pass1007','9541764113'),
(8,'Abhinav Verma','abhinav8@yahoo.com','pass1008','9360219062'),
(9,'Pooja Kulkarni','pooja9@outlook.com','pass1009','9559948018'),
(10,'Aarav Sharma','aarav10@gmail.com','pass1010','9792546637'),
(11,'Karan Sharma','karan11@gmail.com','pass1011','9276740758'),
(12,'Rahul Sharma','rahul12@gmail.com','pass1012','9865682142'),
(13,'Rahul Verma','rahul13@gmail.com','pass1013','9777670630'),
(14,'Karan Sharma','karan14@outlook.com','pass1014','9974715550'),
(15,'Ananya Singh','ananya15@gmail.com','pass1015','9458788916'),
(16,'Priya Joshi','priya16@gmail.com','pass1016','9414888875'),
(17,'Pooja Singh','pooja17@gmail.com','pass1017','9857497144'),
(18,'Rahul Joshi','rahul18@yahoo.com','pass1018','9438763423'),
(19,'Isha Joshi','isha19@outlook.com','pass1019','9811896799'),
(20,'Aarav Sharma','aarav20@gmail.com','pass1020','9866308432'),
(21,'Arjun Patel','arjun21@yahoo.com','pass1021','9114750393'),
(22,'Rahul Patel','rahul22@outlook.com','pass1022','9443399798'),
(23,'Aarav Singh','aarav23@outlook.com','pass1023','9427296538'),
(24,'Sneha Joshi','sneha24@yahoo.com','pass1024','9875482451'),
(25,'Isha Sharma','isha25@yahoo.com','pass1025','9260250251'),
(26,'Arjun Patel','arjun26@yahoo.com','pass1026','9379742352'),
(27,'Isha Singh','isha27@gmail.com','pass1027','9686548211'),
(28,'Arjun Sharma','arjun28@yahoo.com','pass1028','9261057987'),
(29,'Karan Joshi','karan29@gmail.com','pass1029','9918089850'),
(30,'Aarav Verma','aarav30@outlook.com','pass1030','9697679215'),
(31,'Isha Sharma','isha31@yahoo.com','pass1031','9966806167'),
(32,'Pooja Patel','pooja32@gmail.com','pass1032','9159194726'),
(33,'Rohan Singh','rohan33@gmail.com','pass1033','9704352447'),
(34,'Rohan Kulkarni','rohan34@gmail.com','pass1034','9958947283'),
(35,'Rahul Joshi','rahul35@yahoo.com','pass1035','9909718674'),
(36,'Isha Verma','isha36@gmail.com','pass1036','9176959316'),
(37,'Ananya Sharma','ananya37@outlook.com','pass1037','9760295072'),
(38,'Aarav Verma','aarav38@outlook.com','pass1038','9306280750'),
(39,'Rahul Joshi','rahul39@gmail.com','pass1039','9695639372'),
(40,'Aarav Singh','aarav40@yahoo.com','pass1040','9257935229'),
(41,'Neha Kulkarni','neha41@gmail.com','pass1041','9891878414'),
(42,'Rahul Gupta','rahul42@yahoo.com','pass1042','9305393223'),
(43,'Neha Kulkarni','neha43@yahoo.com','pass1043','9785794934'),
(44,'Isha Gupta','isha44@yahoo.com','pass1044','9250670014'),
(45,'Arjun Singh','arjun45@yahoo.com','pass1045','9490314029'),
(46,'Aarav Singh','aarav46@gmail.com','pass1046','9296568719'),
(47,'Pooja Singh','pooja47@outlook.com','pass1047','9844415603'),
(48,'Aarav Singh','aarav48@gmail.com','pass1048','9353079468'),
(49,'Neha Sharma','neha49@outlook.com','pass1049','9637843935'),
(50,'Karan Gupta','karan50@outlook.com','pass1050','9153685866'),
(51,'Rohan Patel','rohan51@outlook.com','pass1051','9790773198'),
(52,'Aarav Verma','aarav52@outlook.com','pass1052','9802406567'),
(53,'Karan Kulkarni','karan53@outlook.com','pass1053','9126921216'),
(54,'Rohan Gupta','rohan54@outlook.com','pass1054','9569033561'),
(55,'Abhinav Sharma','abhinav55@yahoo.com','pass1055','9363317972'),
(56,'Ananya Patel','ananya56@outlook.com','pass1056','9598039976'),
(57,'Isha Gupta','isha57@outlook.com','pass1057','9491631666'),
(58,'Karan Gupta','karan58@yahoo.com','pass1058','9922158347'),
(59,'Neha Sharma','neha59@gmail.com','pass1059','9301833743'),
(60,'Arjun Kulkarni','arjun60@gmail.com','pass1060','9974155843'),
(61,'Rohan Joshi','rohan61@gmail.com','pass1061','9551565810'),
(62,'Abhinav Patel','abhinav62@gmail.com','pass1062','9356343468'),
(63,'Arjun Joshi','arjun63@gmail.com','pass1063','9530077366'),
(64,'Sneha Patel','sneha64@yahoo.com','pass1064','9753108135'),
(65,'Rohan Singh','rohan65@outlook.com','pass1065','9836106379'),
(66,'Rahul Singh','rahul66@outlook.com','pass1066','9734253705'),
(67,'Isha Singh','isha67@outlook.com','pass1067','9538348928'),
(68,'Rohan Gupta','rohan68@yahoo.com','pass1068','9891521668'),
(69,'Aarav Verma','aarav69@gmail.com','pass1069','9631660430'),
(70,'Rahul Patel','rahul70@outlook.com','pass1070','9860884583'),
(71,'Ananya Verma','ananya71@gmail.com','pass1071','9778658812'),
(72,'Neha Verma','neha72@gmail.com','pass1072','9693434484'),
(73,'Pooja Patel','pooja73@outlook.com','pass1073','9213278045'),
(74,'Abhinav Patel','abhinav74@outlook.com','pass1074','9650882941'),
(75,'Isha Joshi','isha75@gmail.com','pass1075','9871763170'),
(76,'Aarav Sharma','aarav76@yahoo.com','pass1076','9848118456'),
(77,'Rohan Joshi','rohan77@outlook.com','pass1077','9565420782'),
(78,'Priya Singh','priya78@outlook.com','pass1078','9161748723'),
(79,'Ananya Verma','ananya79@yahoo.com','pass1079','9572001537'),
(80,'Abhinav Verma','abhinav80@yahoo.com','pass1080','9890581660'),
(81,'Abhinav Verma','abhinav81@outlook.com','pass1081','9539066381'),
(82,'Sneha Joshi','sneha82@outlook.com','pass1082','9425246966'),
(83,'Ananya Gupta','ananya83@yahoo.com','pass1083','9336932822'),
(84,'Rahul Joshi','rahul84@outlook.com','pass1084','9474769271'),
(85,'Rahul Patel','rahul85@yahoo.com','pass1085','9436734877'),
(86,'Rahul Gupta','rahul86@yahoo.com','pass1086','9271372500'),
(87,'Sneha Verma','sneha87@outlook.com','pass1087','9940042444'),
(88,'Isha Patel','isha88@yahoo.com','pass1088','9104556597'),
(89,'Sneha Sharma','sneha89@gmail.com','pass1089','9264988780'),
(90,'Neha Sharma','neha90@yahoo.com','pass1090','9410507282'),
(91,'Pooja Gupta','pooja91@gmail.com','pass1091','9770272138'),
(92,'Karan Singh','karan92@outlook.com','pass1092','9979637696'),
(93,'Arjun Gupta','arjun93@outlook.com','pass1093','9901554126'),
(94,'Neha Verma','neha94@yahoo.com','pass1094','9311940279'),
(95,'Abhinav Verma','abhinav95@outlook.com','pass1095','9248118429'),
(96,'Pooja Joshi','pooja96@outlook.com','pass1096','9447297379'),
(97,'Isha Kulkarni','isha97@outlook.com','pass1097','9112395331'),
(98,'Pooja Verma','pooja98@gmail.com','pass1098','9115395434'),
(99,'Priya Gupta','priya99@outlook.com','pass1099','9406605085'),
(100,'Arjun Sharma','arjun100@outlook.com','pass1100','9101904221'),
(101,'Pooja Joshi','pooja101@gmail.com','pass1101','9826424099'),
(102,'Isha Joshi','isha102@yahoo.com','pass1102','9922118484'),
(103,'Aarav Verma','aarav103@yahoo.com','pass1103','9554586919'),
(104,'Karan Singh','karan104@gmail.com','pass1104','9869246633'),
(105,'Arjun Patel','arjun105@outlook.com','pass1105','9342299452'),
(106,'Rahul Sharma','rahul106@gmail.com','pass1106','9815953245'),
(107,'Rohan Gupta','rohan107@outlook.com','pass1107','9818037269'),
(108,'Pooja Sharma','pooja108@gmail.com','pass1108','9128156572'),
(109,'Ananya Sharma','ananya109@gmail.com','pass1109','9788499127'),
(110,'Arjun Patel','arjun110@gmail.com','pass1110','9380292193'),
(111,'Rohan Sharma','rohan111@outlook.com','pass1111','9102685754'),
(112,'Aarav Sharma','aarav112@outlook.com','pass1112','9241581339'),
(113,'Abhinav Sharma','abhinav113@yahoo.com','pass1113','9580961005'),
(114,'Priya Patel','priya114@outlook.com','pass1114','9736100100'),
(115,'Neha Singh','neha115@yahoo.com','pass1115','9768961765'),
(116,'Isha Joshi','isha116@outlook.com','pass1116','9940673779'),
(117,'Pooja Kulkarni','pooja117@gmail.com','pass1117','9957090720'),
(118,'Pooja Patel','pooja118@gmail.com','pass1118','9598709574'),
(119,'Karan Gupta','karan119@gmail.com','pass1119','9291093973'),
(120,'Pooja Singh','pooja120@gmail.com','pass1120','9255467905'),
(121,'Aarav Kulkarni','aarav121@yahoo.com','pass1121','9602913473'),
(122,'Abhinav Kulkarni','abhinav122@outlook.com','pass1122','9912097017'),
(123,'Neha Gupta','neha123@gmail.com','pass1123','9169669870'),
(124,'Sneha Gupta','sneha124@yahoo.com','pass1124','9611910976'),
(125,'Pooja Sharma','pooja125@yahoo.com','pass1125','9172299218'),
(126,'Neha Patel','neha126@outlook.com','pass1126','9245989720'),
(127,'Neha Patel','neha127@outlook.com','pass1127','9340153388'),
(128,'Rahul Sharma','rahul128@outlook.com','pass1128','9216936374'),
(129,'Pooja Kulkarni','pooja129@outlook.com','pass1129','9741451768'),
(130,'Neha Patel','neha130@yahoo.com','pass1130','9140168452'),
(131,'Neha Joshi','neha131@gmail.com','pass1131','9316082671'),
(132,'Aarav Joshi','aarav132@yahoo.com','pass1132','9190152849'),
(133,'Ananya Singh','ananya133@yahoo.com','pass1133','9651201799'),
(134,'Isha Sharma','isha134@outlook.com','pass1134','9324419059'),
(135,'Arjun Gupta','arjun135@outlook.com','pass1135','9446859786'),
(136,'Priya Patel','priya136@yahoo.com','pass1136','9141748374'),
(137,'Arjun Singh','arjun137@gmail.com','pass1137','9220446343'),
(138,'Pooja Singh','pooja138@gmail.com','pass1138','9438333994'),
(139,'Ananya Singh','ananya139@yahoo.com','pass1139','9546052738'),
(140,'Sneha Singh','sneha140@gmail.com','pass1140','9329601700'),
(141,'Arjun Patel','arjun141@gmail.com','pass1141','9400836617'),
(142,'Karan Gupta','karan142@yahoo.com','pass1142','9314111515'),
(143,'Neha Joshi','neha143@gmail.com','pass1143','9348258171'),
(144,'Rahul Joshi','rahul144@gmail.com','pass1144','9308658370'),
(145,'Priya Gupta','priya145@gmail.com','pass1145','9872208013'),
(146,'Isha Singh','isha146@outlook.com','pass1146','9212668094'),
(147,'Abhinav Patel','abhinav147@outlook.com','pass1147','9440617958'),
(148,'Rahul Verma','rahul148@yahoo.com','pass1148','9556228575'),
(149,'Neha Kulkarni','neha149@outlook.com','pass1149','9672927962'),
(150,'Rahul Joshi','rahul150@outlook.com','pass1150','9897466906'),
(151,'Pooja Joshi','pooja151@gmail.com','pass1151','9120903751'),
(152,'Neha Sharma','neha152@yahoo.com','pass1152','9844650466'),
(153,'Arjun Singh','arjun153@gmail.com','pass1153','9679514840'),
(154,'Rohan Verma','rohan154@gmail.com','pass1154','9203404354'),
(155,'Aarav Sharma','aarav155@yahoo.com','pass1155','9822225205'),
(156,'Neha Joshi','neha156@yahoo.com','pass1156','9233971074'),
(157,'Karan Sharma','karan157@gmail.com','pass1157','9789280670'),
(158,'Rohan Sharma','rohan158@yahoo.com','pass1158','9841889604'),
(159,'Rohan Kulkarni','rohan159@gmail.com','pass1159','9328028595'),
(160,'Isha Sharma','isha160@gmail.com','pass1160','9851036714'),
(161,'Neha Gupta','neha161@yahoo.com','pass1161','9537486437'),
(162,'Abhinav Sharma','abhinav162@yahoo.com','pass1162','9539875387'),
(163,'Isha Patel','isha163@outlook.com','pass1163','9917130391'),
(164,'Isha Singh','isha164@yahoo.com','pass1164','9531792452'),
(165,'Neha Singh','neha165@gmail.com','pass1165','9891812777'),
(166,'Sneha Gupta','sneha166@gmail.com','pass1166','9299791580'),
(167,'Pooja Singh','pooja167@yahoo.com','pass1167','9596102606'),
(168,'Priya Sharma','priya168@outlook.com','pass1168','9564228185'),
(169,'Ananya Patel','ananya169@yahoo.com','pass1169','9761950524'),
(170,'Arjun Joshi','arjun170@yahoo.com','pass1170','9756813620'),
(171,'Karan Sharma','karan171@yahoo.com','pass1171','9984203638'),
(172,'Arjun Singh','arjun172@outlook.com','pass1172','9801941281'),
(173,'Pooja Singh','pooja173@yahoo.com','pass1173','9508247879'),
(174,'Karan Patel','karan174@yahoo.com','pass1174','9325703288'),
(175,'Pooja Sharma','pooja175@gmail.com','pass1175','9146759978'),
(176,'Rahul Singh','rahul176@yahoo.com','pass1176','9930311261'),
(177,'Pooja Kulkarni','pooja177@yahoo.com','pass1177','9551114191'),
(178,'Abhinav Verma','abhinav178@yahoo.com','pass1178','9484158045'),
(179,'Abhinav Singh','abhinav179@outlook.com','pass1179','9477418570'),
(180,'Rahul Singh','rahul180@outlook.com','pass1180','9806946616'),
(181,'Isha Patel','isha181@gmail.com','pass1181','9714310000'),
(182,'Priya Gupta','priya182@outlook.com','pass1182','9401288784'),
(183,'Ananya Joshi','ananya183@gmail.com','pass1183','9469754726'),
(184,'Isha Kulkarni','isha184@yahoo.com','pass1184','9618352638'),
(185,'Sneha Gupta','sneha185@yahoo.com','pass1185','9394702551'),
(186,'Pooja Singh','pooja186@gmail.com','pass1186','9675214964'),
(187,'Karan Gupta','karan187@gmail.com','pass1187','9639136169'),
(188,'Abhinav Joshi','abhinav188@gmail.com','pass1188','9253896547'),
(189,'Karan Sharma','karan189@gmail.com','pass1189','9319324850'),
(190,'Aarav Singh','aarav190@gmail.com','pass1190','9137211146'),
(191,'Abhinav Kulkarni','abhinav191@yahoo.com','pass1191','9279426683'),
(192,'Rohan Sharma','rohan192@gmail.com','pass1192','9914363622'),
(193,'Aarav Sharma','aarav193@gmail.com','pass1193','9617070370'),
(194,'Rahul Sharma','rahul194@gmail.com','pass1194','9472404709'),
(195,'Rahul Joshi','rahul195@outlook.com','pass1195','9435673321'),
(196,'Karan Verma','karan196@outlook.com','pass1196','9358642994'),
(197,'Ananya Singh','ananya197@gmail.com','pass1197','9326080942'),
(198,'Rohan Verma','rohan198@gmail.com','pass1198','9576512968'),
(199,'Aarav Verma','aarav199@gmail.com','pass1199','9761541186'),
(200,'Sneha Verma','sneha200@outlook.com','pass1200','9431030568');

-- Filtered dataset: USER_Table_Filtered p02.xlsx
INSERT INTO data2 (user_id, user_name, email, user_password, phone) VALUES
(1,'Aarav Gupta','aarav1@yahoo.com','pass1001','9616888343'),
(2,'Isha Sharma','isha2@yahoo.com','pass1002','9887401819'),
(3,'Abhinav Joshi','abhinav3@outlook.com','pass1003','9322009580'),
(4,'Arjun Joshi','arjun4@yahoo.com','pass1004','9556631948'),
(5,'Karan Patel','karan5@gmail.com','pass1005','9618632357'),
(6,'Neha Patel','neha6@outlook.com','pass1006','9786905213'),
(7,'Sneha Verma','sneha7@outlook.com','pass1007','9541764113'),
(8,'Abhinav Verma','abhinav8@yahoo.com','pass1008','9360219062'),
(9,'Pooja Kulkarni','pooja9@outlook.com','pass1009','9559948018'),
(10,'Aarav Sharma','aarav10@gmail.com','pass1010','9792546637'),
(11,'Karan Sharma','karan11@gmail.com','pass1011','9276740758'),
(12,'Rahul Sharma','rahul12@gmail.com','pass1012','9865682142'),
(13,'Rahul Verma','rahul13@gmail.com','pass1013','9777670630'),
(14,'Karan Sharma','karan14@outlook.com','pass1014','9974715550'),
(15,'Ananya Singh','ananya15@gmail.com','pass1015','9458788916'),
(16,'Priya Joshi','priya16@gmail.com','pass1016','9414888875'),
(17,'Pooja Singh','pooja17@gmail.com','pass1017','9857497144'),
(18,'Rahul Joshi','rahul18@yahoo.com','pass1018','9438763423'),
(19,'Isha Joshi','isha19@outlook.com','pass1019','9811896799'),
(20,'Aarav Sharma','aarav20@gmail.com','pass1020','9866308432'),
(21,'Arjun Patel','arjun21@yahoo.com','pass1021','9114750393'),
(22,'Rahul Patel','rahul22@outlook.com','pass1022','9443399798'),
(23,'Aarav Singh','aarav23@outlook.com','pass1023','9427296538'),
(24,'Sneha Joshi','sneha24@yahoo.com','pass1024','9875482451'),
(25,'Isha Sharma','isha25@yahoo.com','pass1025','9260250251'),
(26,'Arjun Patel','arjun26@yahoo.com','pass1026','9379742352'),
(27,'Isha Singh','isha27@gmail.com','pass1027','9686548211'),
(28,'Arjun Sharma','arjun28@yahoo.com','pass1028','9261057987'),
(29,'Karan Joshi','karan29@gmail.com','pass1029','9918089850'),
(30,'Aarav Verma','aarav30@outlook.com','pass1030','9697679215'),
(31,'Isha Sharma','isha31@yahoo.com','pass1031','9966806167'),
(32,'Pooja Patel','pooja32@gmail.com','pass1032','9159194726'),
(33,'Rohan Singh','rohan33@gmail.com','pass1033','9704352447'),
(34,'Rohan Kulkarni','rohan34@gmail.com','pass1034','9958947283'),
(35,'Rahul Joshi','rahul35@yahoo.com','pass1035','9909718674'),
(36,'Isha Verma','isha36@gmail.com','pass1036','9176959316'),
(37,'Ananya Sharma','ananya37@outlook.com','pass1037','9760295072'),
(38,'Aarav Verma','aarav38@outlook.com','pass1038','9306280750'),
(39,'Rahul Joshi','rahul39@gmail.com','pass1039','9695639372'),
(40,'Aarav Singh','aarav40@yahoo.com','pass1040','9257935229'),
(41,'Neha Kulkarni','neha41@gmail.com','pass1041','9891878414'),
(42,'Rahul Gupta','rahul42@yahoo.com','pass1042','9305393223'),
(43,'Neha Kulkarni','neha43@yahoo.com','pass1043','9785794934'),
(44,'Isha Gupta','isha44@yahoo.com','pass1044','9250670014'),
(45,'Arjun Singh','arjun45@yahoo.com','pass1045','9490314029'),
(46,'Aarav Singh','aarav46@gmail.com','pass1046','9296568719'),
(47,'Pooja Singh','pooja47@outlook.com','pass1047','9844415603'),
(48,'Aarav Singh','aarav48@gmail.com','pass1048','9353079468'),
(49,'Neha Sharma','neha49@outlook.com','pass1049','9637843935'),
(50,'Karan Gupta','karan50@outlook.com','pass1050','9153685866'),
(51,'Rohan Patel','rohan51@outlook.com','pass1051','9790773198'),
(52,'Aarav Verma','aarav52@outlook.com','pass1052','9802406567'),
(53,'Karan Kulkarni','karan53@outlook.com','pass1053','9126921216'),
(54,'Rohan Gupta','rohan54@outlook.com','pass1054','9569033561'),
(55,'Abhinav Sharma','abhinav55@yahoo.com','pass1055','9363317972'),
(56,'Ananya Patel','ananya56@outlook.com','pass1056','9598039976'),
(57,'Isha Gupta','isha57@outlook.com','pass1057','9491631666'),
(58,'Karan Gupta','karan58@yahoo.com','pass1058','9922158347'),
(59,'Neha Sharma','neha59@gmail.com','pass1059','9301833743'),
(60,'Arjun Kulkarni','arjun60@gmail.com','pass1060','9974155843'),
(61,'Rohan Joshi','rohan61@gmail.com','pass1061','9551565810'),
(62,'Abhinav Patel','abhinav62@gmail.com','pass1062','9356343468'),
(63,'Arjun Joshi','arjun63@gmail.com','pass1063','9530077366'),
(64,'Sneha Patel','sneha64@yahoo.com','pass1064','9753108135'),
(65,'Rohan Singh','rohan65@outlook.com','pass1065','9836106379'),
(66,'Rahul Singh','rahul66@outlook.com','pass1066','9734253705'),
(67,'Isha Singh','isha67@outlook.com','pass1067','9538348928'),
(68,'Rohan Gupta','rohan68@yahoo.com','pass1068','9891521668'),
(69,'Aarav Verma','aarav69@gmail.com','pass1069','9631660430'),
(70,'Rahul Patel','rahul70@outlook.com','pass1070','9860884583'),
(71,'Ananya Verma','ananya71@gmail.com','pass1071','9778658812'),
(72,'Neha Verma','neha72@gmail.com','pass1072','9693434484'),
(73,'Pooja Patel','pooja73@outlook.com','pass1073','9213278045'),
(74,'Abhinav Patel','abhinav74@outlook.com','pass1074','9650882941'),
(75,'Isha Joshi','isha75@gmail.com','pass1075','9871763170'),
(76,'Aarav Sharma','aarav76@yahoo.com','pass1076','9848118456'),
(77,'Rohan Joshi','rohan77@outlook.com','pass1077','9565420782'),
(78,'Priya Singh','priya78@outlook.com','pass1078','9161748723'),
(79,'Ananya Verma','ananya79@yahoo.com','pass1079','9572001537'),
(80,'Abhinav Verma','abhinav80@yahoo.com','pass1080','9890581660'),
(81,'Abhinav Verma','abhinav81@outlook.com','pass1081','9539066381'),
(82,'Sneha Joshi','sneha82@outlook.com','pass1082','9425246966'),
(83,'Ananya Gupta','ananya83@yahoo.com','pass1083','9336932822'),
(84,'Rahul Joshi','rahul84@outlook.com','pass1084','9474769271'),
(85,'Rahul Patel','rahul85@yahoo.com','pass1085','9436734877'),
(86,'Rahul Gupta','rahul86@yahoo.com','pass1086','9271372500'),
(87,'Sneha Verma','sneha87@outlook.com','pass1087','9940042444'),
(88,'Isha Patel','isha88@yahoo.com','pass1088','9104556597'),
(89,'Sneha Sharma','sneha89@gmail.com','pass1089','9264988780'),
(90,'Neha Sharma','neha90@yahoo.com','pass1090','9410507282'),
(91,'Pooja Gupta','pooja91@gmail.com','pass1091','9770272138'),
(92,'Karan Singh','karan92@outlook.com','pass1092','9979637696'),
(93,'Arjun Gupta','arjun93@outlook.com','pass1093','9901554126'),
(94,'Neha Verma','neha94@yahoo.com','pass1094','9311940279'),
(95,'Abhinav Verma','abhinav95@outlook.com','pass1095','9248118429'),
(96,'Pooja Joshi','pooja96@outlook.com','pass1096','9447297379'),
(97,'Isha Kulkarni','isha97@outlook.com','pass1097','9112395331'),
(98,'Pooja Verma','pooja98@gmail.com','pass1098','9115395434'),
(99,'Priya Gupta','priya99@outlook.com','pass1099','9406605085'),
(100,'Arjun Sharma','arjun100@outlook.com','pass1100','9101904221'),
(101,'Pooja Joshi','pooja101@gmail.com','pass1101','9826424099'),
(102,'Isha Joshi','isha102@yahoo.com','pass1102','9922118484'),
(103,'Aarav Verma','aarav103@yahoo.com','pass1103','9554586919'),
(104,'Karan Singh','karan104@gmail.com','pass1104','9869246633'),
(105,'Arjun Patel','arjun105@outlook.com','pass1105','9342299452'),
(106,'Rahul Sharma','rahul106@gmail.com','pass1106','9815953245'),
(107,'Rohan Gupta','rohan107@outlook.com','pass1107','9818037269'),
(108,'Pooja Sharma','pooja108@gmail.com','pass1108','9128156572'),
(109,'Ananya Sharma','ananya109@gmail.com','pass1109','9788499127'),
(110,'Arjun Patel','arjun110@gmail.com','pass1110','9380292193'),
(111,'Rohan Sharma','rohan111@outlook.com','pass1111','9102685754'),
(112,'Aarav Sharma','aarav112@outlook.com','pass1112','9241581339'),
(113,'Abhinav Sharma','abhinav113@yahoo.com','pass1113','9580961005'),
(114,'Priya Patel','priya114@outlook.com','pass1114','9736100100'),
(115,'Neha Singh','neha115@yahoo.com','pass1115','9768961765'),
(116,'Isha Joshi','isha116@outlook.com','pass1116','9940673779'),
(117,'Pooja Kulkarni','pooja117@gmail.com','pass1117','9957090720'),
(118,'Pooja Patel','pooja118@gmail.com','pass1118','9598709574'),
(119,'Karan Gupta','karan119@gmail.com','pass1119','9291093973'),
(120,'Pooja Singh','pooja120@gmail.com','pass1120','9255467905'),
(121,'Aarav Kulkarni','aarav121@yahoo.com','pass1121','9602913473'),
(122,'Abhinav Kulkarni','abhinav122@outlook.com','pass1122','9912097017'),
(123,'Neha Gupta','neha123@gmail.com','pass1123','9169669870'),
(124,'Sneha Gupta','sneha124@yahoo.com','pass1124','9611910976'),
(125,'Pooja Sharma','pooja125@yahoo.com','pass1125','9172299218'),
(126,'Neha Patel','neha126@outlook.com','pass1126','9245989720'),
(127,'Neha Patel','neha127@outlook.com','pass1127','9340153388'),
(128,'Rahul Sharma','rahul128@outlook.com','pass1128','9216936374'),
(129,'Pooja Kulkarni','pooja129@outlook.com','pass1129','9741451768'),
(130,'Neha Patel','neha130@yahoo.com','pass1130','9140168452'),
(131,'Neha Joshi','neha131@gmail.com','pass1131','9316082671'),
(132,'Aarav Joshi','aarav132@yahoo.com','pass1132','9190152849'),
(133,'Ananya Singh','ananya133@yahoo.com','pass1133','9651201799'),
(134,'Isha Sharma','isha134@outlook.com','pass1134','9324419059'),
(135,'Arjun Gupta','arjun135@outlook.com','pass1135','9446859786'),
(136,'Priya Patel','priya136@yahoo.com','pass1136','9141748374'),
(137,'Arjun Singh','arjun137@gmail.com','pass1137','9220446343'),
(138,'Pooja Singh','pooja138@gmail.com','pass1138','9438333994'),
(139,'Ananya Singh','ananya139@yahoo.com','pass1139','9546052738'),
(140,'Sneha Singh','sneha140@gmail.com','pass1140','9329601700'),
(141,'Arjun Patel','arjun141@gmail.com','pass1141','9400836617'),
(142,'Karan Gupta','karan142@yahoo.com','pass1142','9314111515'),
(143,'Neha Joshi','neha143@gmail.com','pass1143','9348258171'),
(144,'Rahul Joshi','rahul144@gmail.com','pass1144','9308658370'),
(145,'Priya Gupta','priya145@gmail.com','pass1145','9872208013'),
(146,'Isha Singh','isha146@outlook.com','pass1146','9212668094'),
(147,'Abhinav Patel','abhinav147@outlook.com','pass1147','9440617958'),
(148,'Rahul Verma','rahul148@yahoo.com','pass1148','9556228575'),
(149,'Neha Kulkarni','neha149@outlook.com','pass1149','9672927962'),
(150,'Rahul Joshi','rahul150@outlook.com','pass1150','9897466906'),
(151,'Pooja Joshi','pooja151@gmail.com','pass1151','9120903751'),
(152,'Neha Sharma','neha152@yahoo.com','pass1152','9844650466'),
(153,'Arjun Singh','arjun153@gmail.com','pass1153','9679514840'),
(154,'Rohan Verma','rohan154@gmail.com','pass1154','9203404354'),
(155,'Aarav Sharma','aarav155@yahoo.com','pass1155','9822225205'),
(156,'Neha Joshi','neha156@yahoo.com','pass1156','9233971074'),
(157,'Karan Sharma','karan157@gmail.com','pass1157','9789280670'),
(158,'Rohan Sharma','rohan158@yahoo.com','pass1158','9841889604'),
(159,'Rohan Kulkarni','rohan159@gmail.com','pass1159','9328028595'),
(160,'Isha Sharma','isha160@gmail.com','pass1160','9851036714'),
(161,'Neha Gupta','neha161@yahoo.com','pass1161','9537486437'),
(162,'Abhinav Sharma','abhinav162@yahoo.com','pass1162','9539875387'),
(163,'Isha Patel','isha163@outlook.com','pass1163','9917130391'),
(164,'Isha Singh','isha164@yahoo.com','pass1164','9531792452'),
(165,'Neha Singh','neha165@gmail.com','pass1165','9891812777'),
(166,'Sneha Gupta','sneha166@gmail.com','pass1166','9299791580'),
(167,'Pooja Singh','pooja167@yahoo.com','pass1167','9596102606'),
(168,'Priya Sharma','priya168@outlook.com','pass1168','9564228185'),
(169,'Ananya Patel','ananya169@yahoo.com','pass1169','9761950524'),
(170,'Arjun Joshi','arjun170@yahoo.com','pass1170','9756813620'),
(171,'Karan Sharma','karan171@yahoo.com','pass1171','9984203638'),
(172,'Arjun Singh','arjun172@outlook.com','pass1172','9801941281'),
(173,'Pooja Singh','pooja173@yahoo.com','pass1173','9508247879'),
(174,'Karan Patel','karan174@yahoo.com','pass1174','9325703288'),
(175,'Pooja Sharma','pooja175@gmail.com','pass1175','9146759978'),
(176,'Rahul Singh','rahul176@yahoo.com','pass1176','9930311261'),
(177,'Pooja Kulkarni','pooja177@yahoo.com','pass1177','9551114191'),
(178,'Abhinav Verma','abhinav178@yahoo.com','pass1178','9484158045'),
(179,'Abhinav Singh','abhinav179@outlook.com','pass1179','9477418570'),
(180,'Rahul Singh','rahul180@outlook.com','pass1180','9806946616'),
(181,'Isha Patel','isha181@gmail.com','pass1181','9714310000'),
(182,'Priya Gupta','priya182@outlook.com','pass1182','9401288784'),
(183,'Ananya Joshi','ananya183@gmail.com','pass1183','9469754726'),
(184,'Isha Kulkarni','isha184@yahoo.com','pass1184','9618352638'),
(185,'Sneha Gupta','sneha185@yahoo.com','pass1185','9394702551'),
(186,'Pooja Singh','pooja186@gmail.com','pass1186','9675214964'),
(187,'Karan Gupta','karan187@gmail.com','pass1187','9639136169'),
(188,'Abhinav Joshi','abhinav188@gmail.com','pass1188','9253896547'),
(189,'Karan Sharma','karan189@gmail.com','pass1189','9319324850'),
(190,'Aarav Singh','aarav190@gmail.com','pass1190','9137211146'),
(191,'Abhinav Kulkarni','abhinav191@yahoo.com','pass1191','9279426683'),
(192,'Rohan Sharma','rohan192@gmail.com','pass1192','9914363622'),
(193,'Aarav Sharma','aarav193@gmail.com','pass1193','9617070370'),
(194,'Rahul Sharma','rahul194@gmail.com','pass1194','9472404709'),
(195,'Rahul Joshi','rahul195@outlook.com','pass1195','9435673321'),
(196,'Karan Verma','karan196@outlook.com','pass1196','9358642994'),
(197,'Ananya Singh','ananya197@gmail.com','pass1197','9326080942'),
(198,'Rohan Verma','rohan198@gmail.com','pass1198','9576512968'),
(199,'Aarav Verma','aarav199@gmail.com','pass1199','9761541186'),
(200,'Sneha Verma','sneha200@outlook.com','pass1200','9431030568');

-- data3: user identity/profile, data4: contact details, data5: credentials.
CREATE TABLE data3 (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE data4 (
    user_id INT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_data4_user FOREIGN KEY (user_id) REFERENCES data3(user_id),
    UNIQUE KEY uq_data4_email (email)
);

CREATE TABLE data5 (
    user_id INT PRIMARY KEY,
    password_hash CHAR(64) NOT NULL,
    password_updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_data5_user FOREIGN KEY (user_id) REFERENCES data3(user_id)
);

-- Audit table used by the trigger.
CREATE TABLE user_audit (
    audit_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    old_email VARCHAR(255) NOT NULL,
    new_email VARCHAR(255) NOT NULL,
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

-- Stored procedure: normalize data1 into data3, data4 and data5.
CREATE PROCEDURE sp_normalize_users()
BEGIN
    INSERT INTO data3 (user_id, user_name)
    SELECT user_id, user_name FROM data1 AS new
    ON DUPLICATE KEY UPDATE user_name = new.user_name;

    INSERT INTO data4 (user_id, email, phone)
    SELECT user_id, email, phone FROM data1 AS new
    ON DUPLICATE KEY UPDATE email = new.email, phone = new.phone;

    INSERT INTO data5 (user_id, password_hash)
    SELECT user_id, SHA2(user_password, 256) FROM data1 AS new
    ON DUPLICATE KEY UPDATE password_hash = SHA2(new.user_password, 256),
                            password_updated_at = CURRENT_TIMESTAMP;
END$$

-- Stored procedure: return users whose email uses a requested domain.
CREATE PROCEDURE sp_users_by_domain(IN requested_domain VARCHAR(255))
BEGIN
    SELECT p.user_id, p.user_name, c.email, c.phone
    FROM data3 AS p
    INNER JOIN data4 AS c ON c.user_id = p.user_id
    WHERE LOWER(SUBSTRING_INDEX(c.email, '@', -1)) = LOWER(requested_domain)
    ORDER BY p.user_id;
END$$

-- Trigger: record contact email changes.
CREATE TRIGGER trg_data4_contact_update
AFTER UPDATE ON data4
FOR EACH ROW
BEGIN
    IF NOT (OLD.email <=> NEW.email) THEN
        INSERT INTO user_audit (user_id, old_email, new_email)
        VALUES (NEW.user_id, OLD.email, NEW.email);
    END IF;
END$$

DELIMITER ;

CALL sp_normalize_users();

-- Various joins.
-- 1. INNER JOIN: users present in both source datasets.
SELECT a.user_id, a.user_name, a.email
FROM data1 AS a
INNER JOIN data2 AS b ON b.user_id = a.user_id;

-- 2. LEFT JOIN: all original users and any matching filtered row.
SELECT a.user_id, a.user_name, b.email AS filtered_email
FROM data1 AS a
LEFT JOIN data2 AS b ON b.user_id = a.user_id;

-- 3. RIGHT JOIN: all filtered users and their original record, when present.
SELECT b.user_id, b.user_name, a.email AS original_email
FROM data1 AS a
RIGHT JOIN data2 AS b ON b.user_id = a.user_id;

-- 4. Multiple-table JOIN: normalized user directory.
SELECT p.user_id, p.user_name, c.email, c.phone, 'credential-present' AS credential_status
FROM data3 AS p
JOIN data4 AS c ON c.user_id = p.user_id
JOIN data5 AS s ON s.user_id = p.user_id;

-- 5. SELF JOIN: pairs of users sharing the same email domain.
SELECT a.user_name AS user_a, b.user_name AS user_b,
       SUBSTRING_INDEX(a.email, '@', -1) AS email_domain
FROM data1 AS a
JOIN data1 AS b
  ON SUBSTRING_INDEX(a.email, '@', -1) = SUBSTRING_INDEX(b.email, '@', -1)
 AND a.user_id < b.user_id;

-- Correlated subquery: compare each user with the average ID of their email domain.
SELECT d.user_id, d.user_name, d.email
FROM data1 AS d
WHERE d.user_id > (
    SELECT AVG(other.user_id)
    FROM data1 AS other
    WHERE SUBSTRING_INDEX(other.email, '@', -1) =
          SUBSTRING_INDEX(d.email, '@', -1)
)
ORDER BY d.user_id;

-- Another correlated subquery: users whose domain occurs at least twice.
SELECT d.user_id, d.user_name, d.email
FROM data1 AS d
WHERE 2 <= (
    SELECT COUNT(*)
    FROM data1 AS same_domain
    WHERE SUBSTRING_INDEX(same_domain.email, '@', -1) =
          SUBSTRING_INDEX(d.email, '@', -1)
);

-- Views.
CREATE OR REPLACE VIEW vw_user_directory AS
SELECT p.user_id, p.user_name, c.email, c.phone
FROM data3 AS p
JOIN data4 AS c ON c.user_id = p.user_id;

CREATE OR REPLACE VIEW vw_email_domains AS
SELECT SUBSTRING_INDEX(email, '@', -1) AS email_domain,
       COUNT(*) AS user_count
FROM data4
GROUP BY SUBSTRING_INDEX(email, '@', -1);

-- View usage.
SELECT * FROM vw_user_directory ORDER BY user_id;
SELECT * FROM vw_email_domains ORDER BY user_count DESC, email_domain;

-- Procedure usage example:
-- CALL sp_users_by_domain('gmail.com');

-- Trigger verification example:
-- UPDATE data4 SET email = 'updated@example.com' WHERE user_id = 1;
-- SELECT * FROM user_audit ORDER BY audit_id DESC;
