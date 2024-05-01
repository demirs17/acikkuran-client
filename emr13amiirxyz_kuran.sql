-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: localhost:3306
-- Üretim Zamanı: 07 Eki 2023, 22:40:23
-- Sunucu sürümü: 8.0.34
-- PHP Sürümü: 8.1.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `emr13amiirxyz_kuran`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `favori_ayetler`
--

CREATE TABLE `favori_ayetler` (
  `id` int NOT NULL,
  `sure_no` int NOT NULL,
  `ayet_no` int NOT NULL,
  `aciklama` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
-- collation hata verirse => ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

--
-- Tablo döküm verisi `favori_ayetler`
--

INSERT INTO `favori_ayetler` (`id`, `sure_no`, `ayet_no`, `aciklama`) VALUES
(8, 7, 163, '1'),
(9, 47, 31, '1'),
(10, 7, 57, '2'),
(11, 51, 47, '2'),
(12, 51, 48, '2'),
(18, 29, 49, NULL),
(19, 53, 28, '3'),
(20, 67, 10, NULL),
(21, 54, 22, '3'),
(22, 72, 5, '3'),
(23, 56, 57, '2'),
(24, 56, 62, '2'),
(25, 2, 191, NULL),
(26, 57, 7, '1'),
(27, 57, 10, '1'),
(29, 60, 8, NULL),
(30, 60, 9, NULL),
(31, 61, 3, '1'),
(32, 61, 7, '3'),
(33, 102, 8, '1'),
(34, 70, 24, '1'),
(35, 71, 17, '2'),
(36, 72, 2, '3'),
(38, 21, 30, '2'),
(39, 79, 20, NULL),
(40, 2, 45, '1'),
(41, 39, 18, '1'),
(42, 83, 1, '1'),
(44, 91, 8, NULL),
(45, 92, 6, NULL),
(46, 92, 18, '1'),
(47, 98, 5, '1'),
(48, 102, 1, '1'),
(49, 104, 1, '1'),
(50, 51, 7, '2'),
(51, 3, 191, '2'),
(52, 30, 21, NULL),
(53, 36, 39, NULL),
(54, 4, 19, NULL),
(55, 2, 38, NULL),
(56, 2, 51, NULL),
(57, 2, 89, NULL),
(58, 2, 155, NULL),
(59, 2, 164, NULL),
(60, 2, 170, NULL),
(61, 12, 111, NULL),
(62, 31, 6, NULL),
(63, 2, 177, NULL),
(64, 2, 221, NULL),
(65, 2, 261, NULL),
(66, 2, 265, NULL),
(67, 2, 277, NULL),
(68, 32, 17, NULL),
(69, 3, 40, NULL),
(70, 3, 66, NULL),
(71, 3, 78, NULL),
(72, 3, 94, NULL),
(73, 3, 140, NULL),
(74, 3, 190, NULL),
(77, 71, 14, NULL),
(78, 12, 105, NULL),
(79, 5, 112, NULL),
(80, 5, 115, NULL),
(81, 4, 6, NULL),
(82, 2, 229, NULL),
(83, 76, 1, NULL),
(86, 35, 37, NULL),
(87, 5, 33, NULL);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `preferences`
--

CREATE TABLE `preferences` (
  `id` int NOT NULL,
  `anahtar` varchar(255) NOT NULL,
  `deger` varchar(255) NOT NULL






-- orjinal ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;







-- ??????????????????????????????????????????????????




) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;



-- ??????????????????????????????????????????????????

















--
-- Tablo döküm verisi `preferences`
--

INSERT INTO `preferences` (`id`, `anahtar`, `deger`) VALUES
(1, 'kaldigim_sure_sirasi', '4'),
(2, 'secili_meal', 'okuyan'),
(3, 'tema_renk', '0xff2f1010'),
(4, 'secili_meal_kod', '105'),
(5, 'secili_meal_kod_isim', 'Erhan Aktaş');

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `favori_ayetler`
--
ALTER TABLE `favori_ayetler`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `preferences`
--
ALTER TABLE `preferences`
  ADD PRIMARY KEY (`id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `favori_ayetler`
--
ALTER TABLE `favori_ayetler`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=88;

--
-- Tablo için AUTO_INCREMENT değeri `preferences`
--
ALTER TABLE `preferences`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
