USE analise_risco;
-- ENTENDENDO QUAIS INFORMACOES O CONJUNTO DE DADOS POSSUI 
-- ANALISAR QUAIS OS TIPOS DE DADOS

SELECT * FROM emprestimos LIMIT 5;
DESCRIBE emprestimos; -- CONTEM INFORMACOES DOS EMPRESTIMOS SOLICITADOS

SELECT * FROM ids LIMIT 5;
DESCRIBE ids; -- RELACIONA OS DADOS DE CADA INFORMACAO DA PESSOA SOLICITANTE

SELECT * FROM dados_mutuarios LIMIT 5;
DESCRIBE dados_mutuarios; -- DADOS PESSOAIS DE CADA SOLICITANTE

SELECT * FROM historicos_banco LIMIT 5;
DESCRIBE historicos_banco; -- HISTORICO DE EMPRESTIMO DE CADA CLIENTE

-- person_emp_length double -> int

-- VERIFICAR QUAIS SÃO AS INCONSISTÊNCIAS NOS DADOS

-- ### Analisando a tabela dados_mutuarios ### 
-- Verificando valores nulos
SELECT * FROM dados_mutuarios LIMIT 5;
SELECT * FROM dados_mutuarios WHERE person_id IS NULL;
SELECT * FROM dados_mutuarios WHERE person_age IS NULL; -- Diversos valores de idade nulos
SELECT * FROM dados_mutuarios WHERE person_income IS NULL; -- Diversos valores de salário anual nulos
SELECT * FROM dados_mutuarios WHERE person_home_ownership is NULL;
SELECT * FROM dados_mutuarios WHERE person_emp_length is NULL; -- Diversos valores de tempo em anos de trabalho nulos 

-- Verificando duplicatas
SELECT person_id, COUNT(person_id)
FROM dados_mutuarios
GROUP BY person_id
HAVING COUNT(person_id) > 1;
-- Ao executar a query anterior descobriu-se que há valores de person_id = ''
SELECT * FROM dados_mutuarios WHERE person_id = ''; -- REMOVER
-- Verificando outras colunas que possuem vazio: (poderia ter usado a cláusula OR quando os valores nulos foram verificados)
SELECT * FROM dados_mutuarios WHERE person_home_ownership = ''; -- TRATAR
SELECT * FROM dados_mutuarios WHERE person_emp_length = ''; -- TRATAR

-- Verificando valores para a idade:
SELECT person_age FROM dados_mutuarios WHERE person_age NOT BETWEEN 18 and 113; -- Há 5 pessoas com mais que 113 anos (idade da pessoa mais velha do Brasil) e nenhuma menor que 18 anos

-- Verificando valores para o tempo de servico
SELECT person_age, person_emp_length FROM dados_mutuarios WHERE person_emp_length > 84; -- Há duas pessoas que trabalharam por mais que 84 anos ( tempo de um funcionario que mais trabalhou no mundo)

-- ### Analisando a tabela emprestimos ### 
SELECT * FROM emprestimos LIMIT 5;
-- Verificando valores nulos ou vazios
SELECT loan_id FROM emprestimos WHERE loan_id = '' OR loan_id IS NULL;
SELECT loan_intent FROM emprestimos WHERE loan_intent = '' OR loan_intent IS NULL; -- Há valores vazios
SELECT loan_grade FROM emprestimos WHERE loan_grade = '' OR loan_grade IS NULL; -- Há valores vazios
SELECT loan_amnt FROM emprestimos WHERE loan_amnt = '' OR loan_amnt IS NULL; -- Há valores nulos
SELECT loan_int_rate FROM emprestimos WHERE loan_int_rate = '' OR loan_int_rate IS NULL;  -- Há valores nulos
SELECT DISTINCT loan_status FROM emprestimos; -- loan_status só é 0 ou 1 ou nulo
SELECT loan_status FROM emprestimos WHERE loan_status is NULL; -- Há valores nulos
SELECT loan_percent_income FROM emprestimos WHERE loan_percent_income = '' OR loan_percent_income IS NULL; -- Há valores nulos e 0

-- Verificando duplicatas
SELECT loan_id, COUNT(loan_id)
FROM emprestimos
GROUP BY loan_id
HAVING COUNT(loan_id) > 1; -- Não há valores duplicados

-- ### Analisando a tabela historicos_banco ###
SELECT * FROM historicos_banco LIMIT 5;
-- Verificando valores nulos ou vazios
SELECT cb_id FROM historicos_banco WHERE cb_id is NULL OR cb_id = '';
SELECT cb_person_default_on_file FROM historicos_banco WHERE cb_person_default_on_file is NULL OR cb_person_default_on_file = ''; -- Há valores vazios
SELECT cb_person_cred_hist_length FROM historicos_banco WHERE cb_person_cred_hist_length is NULL OR cb_person_cred_hist_length = ''; -- Há um valor nulo

-- Verificando duplicatas 

SELECT cb_id, COUNT(cb_id)
FROM historicos_banco
GROUP BY cb_id
HAVING COUNT(cb_id) > 1; -- Não há valores duplicados

-- Verificando se há valores ilógicos na coluna cb_person_cred_hist_length
SELECT MAX(cb_person_cred_hist_length) FROM historicos_banco;
SELECT MIN(cb_person_cred_hist_length) FROM historicos_banco;

-- ### Analisando a tabela ids ###
SELECT * FROM ids LIMIT 5;

-- Verificando valores nulos ou vazios
SELECT person_id FROM ids WHERE person_id IS NULL OR person_id = ''; -- 4 valores vazios
SELECT loan_id FROM ids WHERE loan_id IS NULL OR loan_id = '';
SELECT cb_id FROM ids WHERE cb_id IS NULL OR cb_id = '';

-- Verificando duplicatas
SELECT person_id, COUNT(person_id)
FROM ids
GROUP BY person_id
HAVING COUNT(person_id) > 1; -- 4 valores vazios

SELECT loan_id, COUNT(loan_id)
FROM ids
GROUP BY loan_id
HAVING COUNT(loan_id) > 1; 

SELECT cb_id, COUNT(cb_id)
FROM ids
GROUP BY cb_id
HAVING COUNT(cb_id) > 1; 

-- Outros problemas: Esse problemas estão relacionados na forma em que a as colunas das tabelas foram estruturadas. Portanto, faz-se necessário reestruturar alguns aspectos, como por exemplo,
-- atribuir à algumas colunas o atributo de primary key (dados_mutuarios -> person_id ; emprestimos -> loan_id ; historicos_banco -> cb_id) e como a tabela ids relaciona os IDs de cada informacao,
-- da pessoa solicitante, irei atribuir as suas colunas a propriedade de foreign key. Além disso, algumas colunas estão com o tipo de dado que diminui o desempenho, portanto haverá alteracoes.

-- primary key (dados_mutuarios -> person_id ; emprestimos -> loan_id ; historicos_banco -> cb_id)
DELETE FROM dados_mutuarios WHERE person_id = '';
ALTER TABLE dados_mutuarios ADD PRIMARY KEY (person_id);
ALTER TABLE emprestimos ADD PRIMARY KEY (loan_id);
ALTER TABLE historicos_banco ADD PRIMARY KEY (cb_id);

-- foreign key ( ids )
-- Ajustando Error Code: 3780. Referencing column 'person_id' and referenced column 'person_id' in foreign key constraint 'fk_ids_dados_mutuarios' are incompatible.

DELETE FROM ids WHERE person_id = '';

ALTER TABLE ids 
MODIFY person_id VARCHAR(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

ALTER TABLE dados_mutuarios 
MODIFY person_id VARCHAR(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

ALTER TABLE emprestimos
MODIFY loan_id VARCHAR(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

ALTER TABLE historicos_banco
MODIFY cb_id VARCHAR(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

ALTER TABLE ids MODIFY person_id VARCHAR(16) NOT NULL;
ALTER TABLE ids MODIFY loan_id VARCHAR(16) NOT NULL;
ALTER TABLE ids MODIFY cb_id VARCHAR(16) NOT NULL;

ALTER TABLE ids ADD CONSTRAINT fk_ids_dados_mutuarios 
FOREIGN KEY(person_id) REFERENCES dados_mutuarios(person_id) ON DELETE CASCADE;

ALTER TABLE ids ADD CONSTRAINT fk_ids_emprestimos 
FOREIGN KEY(loan_id) REFERENCES emprestimos(loan_id) ON DELETE CASCADE;

ALTER TABLE ids ADD CONSTRAINT fk_ids_historicos_banco 
FOREIGN KEY(cb_id) REFERENCES historicos_banco(cb_id) ON DELETE CASCADE;

-- Alterando o tipo de person_emp_length
ALTER TABLE dados_mutuarios MODIFY person_emp_length INT;

-- TRATANDO dados_mutuarios

DELETE FROM dados_mutuarios WHERE person_age IS NULL OR person_income IS NULL;
DELETE FROM dados_mutuarios WHERE person_emp_length IS NULL;
DELETE FROM dados_mutuarios WHERE person_home_ownership = '' OR person_emp_length = '';
UPDATE dados_mutuarios SET person_age = 77 WHERE person_age NOT BETWEEN 18 and 113;
DELETE FROM dados_mutuarios WHERE person_emp_length > 84;


-- TRATANDO emprestimos

DELETE FROM emprestimos WHERE loan_intent = '' OR loan_intent IS NULL;
DELETE FROM emprestimos WHERE loan_grade = '' OR loan_grade IS NULL;
DELETE FROM emprestimos WHERE loan_amnt = '' OR loan_amnt IS NULL;
DELETE FROM emprestimos WHERE loan_int_rate = '' OR loan_int_rate IS NULL;
DELETE FROM emprestimos WHERE loan_status is NULL;
DELETE FROM emprestimos WHERE loan_percent_income = '' OR loan_percent_income IS NULL;

-- TRATANDO historicos_banco

DELETE FROM historicos_banco WHERE cb_person_default_on_file is NULL OR cb_person_default_on_file = '';
DELETE FROM historicos_banco WHERE cb_person_cred_hist_length is NULL OR cb_person_cred_hist_length = '';

CREATE VIEW vw_dados_mutuarios_ids AS
SELECT 
A.person_id, 
A.person_age, 
A.person_income,
A.person_home_ownership, 
A.person_emp_length, 
ids.loan_id, 
ids.cb_id 
FROM dados_mutuarios A
INNER JOIN ids
ON A.person_id = ids.person_id;

CREATE VIEW vw_dados_mutuarios_emprestimos AS
SELECT
A.person_age, 
A.person_income,
A.person_home_ownership, 
A.person_emp_length,
A.cb_id, 
B.loan_intent,
B.loan_grade,
B.loan_amnt,
B.loan_int_rate,
B.loan_status,
B.loan_percent_income
FROM vw_dados_mutuarios_ids A
INNER JOIN emprestimos B
ON A.loan_id = B.loan_id;

SELECT * FROM vw_dados_mutuarios_emprestimos;

CREATE TABLE dados_agrupados AS
SELECT 
A.person_age, 
A.person_income,
A.person_home_ownership, 
A.person_emp_length,
A.loan_intent,
A.loan_grade,
A.loan_amnt,
A.loan_int_rate,
A.loan_status,
A.loan_percent_income,
B.cb_person_default_on_file,
B.cb_person_cred_hist_length
FROM vw_dados_mutuarios_emprestimos A
INNER JOIN historicos_banco B
ON A.cb_id = B.cb_id;


SELECT * FROM dados_agrupados;







