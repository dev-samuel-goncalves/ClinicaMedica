CREATE DATABASE IF NOT EXISTS clinica_medica CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE clinica_medica;

-- Exclui as tabelas na ordem inversa de dependência
DROP TABLE IF EXISTS Exame;
DROP TABLE IF EXISTS Receita;
DROP TABLE IF EXISTS Consulta;
DROP TABLE IF EXISTS Medico;
DROP TABLE IF EXISTS Paciente;


SET SQL_SAFE_UPDATES = 0;

-- 2. CRIAÇÃO DAS TABELAS

CREATE TABLE Paciente (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    data_nascimento DATE NOT NULL,
    sexo CHAR(1),
    telefone VARCHAR(20),
    endereco VARCHAR(255)
);


CREATE TABLE Medico (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    especialidade VARCHAR(100) NOT NULL,
    crm VARCHAR(20) NOT NULL UNIQUE,
    telefone VARCHAR(20)
);


CREATE TABLE Consulta (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    data_hora DATETIME NOT NULL,
    observacoes TEXT,
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES Medico(id_medico)
);


CREATE TABLE Receita (
    id_receita INT AUTO_INCREMENT PRIMARY KEY,
    id_consulta INT NOT NULL,
    descricao TEXT NOT NULL,
    FOREIGN KEY (id_consulta) REFERENCES Consulta(id_consulta)
);


CREATE TABLE Exame (
    id_exame INT AUTO_INCREMENT PRIMARY KEY,
    id_consulta INT NOT NULL,
    tipo VARCHAR(100) NOT NULL,
    resultado TEXT,
    FOREIGN KEY (id_consulta) REFERENCES Consulta(id_consulta)
);


-- 3. INSERÇÃO DE DADOS



INSERT INTO Paciente (nome, data_nascimento, sexo, telefone, endereco) VALUES
('Maria Silva', '1985-10-20', 'F', '11987654321', 'Rua A, 100, São Paulo/SP'),
('João Santos', '1992-05-15', 'M', '21998765432', 'Av. B, 50, Rio de Janeiro/RJ'),
('Ana Oliveira', '2000-01-01', 'F', '31976543210', 'Rua C, 200, Belo Horizonte/MG');


INSERT INTO Medico (nome, especialidade, crm, telefone) VALUES
('Dr. Ana Costa', 'Cardiologia', 'CRM/SP 12345', '1130001111'),
('Dra. Pedro Oliveira', 'Dermatologia', 'CRM/MG 67890', '3130002222'),
('Dr. Laura Mendes', 'Pediatria', 'CRM/RJ 54321', '2130003333');


INSERT INTO Consulta (id_paciente, id_medico, data_hora, observacoes) VALUES
(1, 1, '2025-09-28 10:00:00', 'Paciente com queixa de palpitações. Solicitado ECG e Teste Ergométrico.'),
(2, 2, '2025-09-29 14:30:00', 'Revisão de rotina. Lesão de pele controlada.'),
(3, 3, '2025-09-29 16:00:00', 'Consulta de acompanhamento pediátrico. Sem intercorrências.');


INSERT INTO Receita (id_consulta, descricao) VALUES
(1, 'Atenolol 25mg - 1x ao dia por 30 dias.'),
(2, 'Pomada Tópica de Corticoide - aplicar na área afetada 2x ao dia.');


INSERT INTO Exame (id_consulta, tipo, resultado) VALUES
(1, 'Eletrocardiograma (ECG)', 'Resultado normal, sem alterações.'),
(1, 'Teste Ergométrico', NULL),
(2, 'Hemograma Completo', 'Aguardando resultado.');


-- 4. MANIPULAÇÃO DE DADOS (SELECTs e UPDATEs)


UPDATE Exame
SET resultado = 'Teste positivo para isquemia. Necessário acompanhamento.'
WHERE id_exame = 2;

UPDATE Paciente
SET
    telefone = '21999990000',
    endereco = 'Rua Nova, 500, Rio de Janeiro/RJ'
WHERE
    nome = 'João Santos';


SELECT
    P.nome AS Paciente,
    M.nome AS Medico,
    M.especialidade,
    C.data_hora
FROM
    Consulta C
JOIN Paciente P ON C.id_paciente = P.id_paciente
JOIN Medico M ON C.id_medico = M.id_medico
ORDER BY C.data_hora DESC;


SELECT
    C.data_hora AS Data_Consulta,
    E.tipo AS Exame,
    R.descricao AS Receita_Prescrita
FROM
    Consulta C
LEFT JOIN Exame E ON C.id_consulta = E.id_consulta
LEFT JOIN Receita R ON C.id_consulta = R.id_consulta
WHERE
    C.id_consulta = 1;