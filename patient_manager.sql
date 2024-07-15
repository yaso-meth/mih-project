-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: mysqlDB:3306
-- Generation Time: Jul 15, 2024 at 02:55 PM
-- Server version: 9.0.0
-- PHP Version: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `patient_manager`
--

-- --------------------------------------------------------

--
-- Table structure for table `doctor_offices`
--

CREATE TABLE `doctor_offices` (
  `iddoctor_offices` int NOT NULL,
  `office_name` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `doctor_offices`
--

INSERT INTO `doctor_offices` (`iddoctor_offices`, `office_name`) VALUES
(12345, 'YasoTest'),
(54321, 'IkyTest');

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `idpatients` int NOT NULL,
  `id_no` varchar(13) DEFAULT NULL,
  `first_name` varchar(128) DEFAULT NULL,
  `last_name` varchar(128) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `cell_no` varchar(45) DEFAULT NULL,
  `medical_aid_name` varchar(128) DEFAULT NULL,
  `medical_aid_no` varchar(45) DEFAULT NULL,
  `medical_aid_scheme` varchar(128) DEFAULT NULL,
  `address` varchar(256) DEFAULT NULL,
  `doc_office_id` int DEFAULT NULL,
  `medical_aid` varchar(45) DEFAULT NULL,
  `medical_aid_main_member` varchar(45) DEFAULT NULL,
  `medical_aid_code` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`idpatients`, `id_no`, `first_name`, `last_name`, `email`, `cell_no`, `medical_aid_name`, `medical_aid_no`, `medical_aid_scheme`, `address`, `doc_office_id`, `medical_aid`, `medical_aid_main_member`, `medical_aid_code`) VALUES
(1, '9505185437083', 'Yasien', 'Meth', 'Yasienmeth@gmail.com', '0788300006', 'BankMed', '123456789', 'Core Saver', '8 Arterial Road East', 12345, 'Yes', 'Yes', '01'),
(2, '6902101234567', 'Iky', 'Meth', 'iky.meth@gmail.com', '0845953472', 'BankMed', '123456789', 'Core Saver', '21 Sports Road', 12345, 'Yes', 'No', '02'),
(3, '700210', 'Nashieta', 'Meth', 'nashietameth@gmail.com', '0845548821', 'BankMed', '987654321', 'Comprihensive', '21 Sports Road', 54321, 'Yes', 'Yes', '01'),
(9, '920109', 'Razeen', 'Meth', 'Razeenmeth@gmail.com', '0781234567', 'BankMed', '147258369', 'Traditional', '4 Siros Road', 54321, 'Yes', 'Yes', '01'),
(10, '920109123', 'Razeen', 'Meth', 'Razeenmeth@gmail.com', '0781234567', 'BankMed', '147258369', 'Traditional', '4 Siros Road', 54321, 'Yes', 'Yes', '01'),
(29, 'test 1', 'test 1', 'test 1', 'test 1', 'test 1', 'test 1', 'test 1', 'test 1', 'test 1', 12345, 'Yes', 'No', 'test 1'),
(30, 'test 2', 'test 2', 'test 2', 'test 2', 'test 2', '', '', '', 'test 2', 12345, 'No', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `patient_files`
--

CREATE TABLE `patient_files` (
  `idpatient_files` int NOT NULL,
  `file_path` varchar(256) DEFAULT NULL,
  `file_name` varchar(128) DEFAULT NULL,
  `patient_id` int DEFAULT NULL,
  `insert_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `patient_files`
--

INSERT INTO `patient_files` (`idpatient_files`, `file_path`, `file_name`, `patient_id`, `insert_date`) VALUES
(16, 'Med-Cert-Yasien Meth-2024-06-27.pdf', 'Med-Cert-Yasien Meth-2024-06-27.pdf', 1, '2024-06-27'),
(17, 'Contact-sheet.pdf', 'Contact-sheet.pdf', 1, '2024-06-27'),
(18, 'test-(1).pdf', 'test-(1).pdf', 1, '2024-06-27'),
(19, 'Certificate-of-Service.pdf', 'Certificate-of-Service.pdf', 1, '2024-06-28'),
(20, 'Docs.pdf', 'Docs.pdf', 1, '2024-07-03'),
(21, 'Med-Cert-Yasien Meth-2024-07-03.pdf', 'Med-Cert-Yasien Meth-2024-07-03.pdf', 1, '2024-07-03'),
(22, 'Med-Cert-Yasien Meth-2024-07-04.pdf', 'Med-Cert-Yasien Meth-2024-07-04.pdf', 1, '2024-07-04'),
(23, 'Med-Cert-Yasien Meth-2024-07-05.pdf', 'Med-Cert-Yasien Meth-2024-07-05.pdf', 1, '2024-07-04'),
(24, 'SBGRF-Withdrawal-Option-Form.pdf', 'SBGRF-Withdrawal-Option-Form.pdf', 1, '2024-07-04'),
(25, 'Screenshot_20230623_175846_Twitter.jpg', 'Screenshot_20230623_175846_Twitter.jpg', 1, '2024-07-04'),
(26, 'asus.jpg', 'asus.jpg', 1, '2024-07-04'),
(27, 'Med-Cert-Yasien Meth-2024-07-15.pdf', 'Med-Cert-Yasien Meth-2024-07-15.pdf', 1, '2024-07-13'),
(28, 'Med-Cert-Yasien Meth-2024-07-15.pdf', 'Med-Cert-Yasien Meth-2024-07-15.pdf', 1, '2024-07-13'),
(29, 'Med-Cert-Yasien Meth-2024-07-15.pdf', 'Med-Cert-Yasien Meth-2024-07-15.pdf', 1, '2024-07-13'),
(30, 'Med-Cert-Yasien Meth-2024-07-15.pdf', 'Med-Cert-Yasien Meth-2024-07-15.pdf', 1, '2024-07-13'),
(31, 'Med-Cert-Yasien Meth-.pdf', 'Med-Cert-Yasien Meth-.pdf', 1, '2024-07-13');

-- --------------------------------------------------------

--
-- Table structure for table `patient_notes`
--

CREATE TABLE `patient_notes` (
  `idpatient_notes` int NOT NULL,
  `note_name` varchar(128) DEFAULT NULL,
  `note_text` varchar(512) DEFAULT NULL,
  `patient_id` int DEFAULT NULL,
  `insert_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `patient_notes`
--

INSERT INTO `patient_notes` (`idpatient_notes`, `note_name`, `note_text`, `patient_id`, `insert_date`) VALUES
(1, 'First Note', 'This is the forst note for this patient', 1, '2024-03-13'),
(2, 'Second Note', 'This is the second not for this patient', 1, '2024-03-14'),
(3, 'Third Note', 'This is third note', 2, '2024-03-15'),
(4, 'API insert Note', 'This is the first note made with API, it was also modified bu api', 1, '2024-03-23'),
(5, 'app note 1', 'from the app\nmultiline\nthe best', 1, '2024-06-20'),
(6, 'app note 2', 'testing', 1, '2024-06-20'),
(7, 'app note 3', 'testing', 1, '2024-06-20'),
(8, 'app note 4', 'testing', 1, '2024-06-20'),
(9, 'note 4', 'testing', 1, '2024-06-20'),
(10, 'note 5', 'cysbd', 1, '2024-06-20'),
(11, 'note 6', 'tester', 1, '2024-06-20'),
(12, 'Note for today', 'this is the note\nhello', 1, '2024-06-21'),
(13, 'Not for today 2', 'sicky patient\nneeds medicine\ncovid is lit', 1, '2024-06-21'),
(14, 'consultation', 'testtestte', 1, '2024-06-26'),
(15, 'Testing new pop up', 'testing the new popup window', 1, '2024-07-03'),
(16, 'testing new success popup', 'new success pop up added', 1, '2024-07-04'),
(17, 'test', 'test', 1, '2024-07-08'),
(18, 'consultation', 'testing \nsick', 1, '2024-07-13');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `idusers` int NOT NULL,
  `email` varchar(128) DEFAULT NULL,
  `docOffice_id` int DEFAULT NULL,
  `fname` varchar(128) DEFAULT NULL,
  `lname` varchar(128) DEFAULT NULL,
  `title` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`idusers`, `email`, `docOffice_id`, `fname`, `lname`, `title`) VALUES
(1, 'yasienmeth@gmail.com', 12345, 'Yaso', 'Meth', 'Dr'),
(2, 'iky.meth@gmail.com', 12345, NULL, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `doctor_offices`
--
ALTER TABLE `doctor_offices`
  ADD PRIMARY KEY (`iddoctor_offices`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`idpatients`),
  ADD KEY `doc_office_is_idx` (`doc_office_id`);

--
-- Indexes for table `patient_files`
--
ALTER TABLE `patient_files`
  ADD PRIMARY KEY (`idpatient_files`),
  ADD KEY `patientID_idx` (`patient_id`);

--
-- Indexes for table `patient_notes`
--
ALTER TABLE `patient_notes`
  ADD PRIMARY KEY (`idpatient_notes`),
  ADD KEY `patient_id_idx` (`patient_id`),
  ADD KEY `patient_id_id2` (`patient_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`idusers`),
  ADD KEY `docid_idx` (`docOffice_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `idpatients` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `patient_files`
--
ALTER TABLE `patient_files`
  MODIFY `idpatient_files` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `patient_notes`
--
ALTER TABLE `patient_notes`
  MODIFY `idpatient_notes` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `idusers` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `patients`
--
ALTER TABLE `patients`
  ADD CONSTRAINT `doc_office_is` FOREIGN KEY (`doc_office_id`) REFERENCES `doctor_offices` (`iddoctor_offices`);

--
-- Constraints for table `patient_notes`
--
ALTER TABLE `patient_notes`
  ADD CONSTRAINT `patientFK` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`idpatients`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `docid` FOREIGN KEY (`docOffice_id`) REFERENCES `doctor_offices` (`iddoctor_offices`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
