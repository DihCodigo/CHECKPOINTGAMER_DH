-- SQL
-- 1- EXIBIR TODOS OS DADOS DA TABELA CLIENTES
SELECT * FROM USUARIOS;
SELECT * FROM CLIENTES;
SELECT * FROM ENDERECOS;

-- 1.1- INSERIR CLIENTE NO SISTEMA
INSERT INTO USUARIOS(ID, NOME_USUARIO, EMAIL_USUARIO, SENHA_USUARIO, IS_ADMIN)
VALUES
(NULL, 'JORGE COUTINHO', 'JORJAO@GMAIL.COM', 'A2223A4', 0);

INSERT INTO CLIENTES (ID, ID_USUARIO, DATA_NASC_CLIENTE, CPF_CLIENTE, FONE1_CLIENTE, FONE2_CLIENTE)
VALUES
(NULL, '6', '1991-12-28', '987-710-221-30', '(12)98921-1890', NULL);

INSERT INTO ENDERECOS (ID, ID_CLIENTE, ENDERECO_CLIENTE, BAIRRO_CLIENTE, NUMERO_CLIENTE, CIDADE_CLIENTE, ESTADO_CLIENTE)
VALUES
(NULL, '6', 'RUA ALFREDO TEXEIRA MACHADO', 'VILA REGINA CELIA', '232', 'CRUZEIRO', 'SÃO PAULO');


-- 1.1 -- VERIFICAR REGISTRO DE CLIENTE DUPLICADO


--  2- ATUALIZAR DADOS CADASTRADOS -> ATUALIZAR TROCA DE ENDEREÇO
UPDATE ENDERECOS 
SET ENDERECO_CLIENTE = 'RUA SETE DE SETEMBRO', BAIRRO_CLIENTE = 'CENTRO', NUMERO_CLIENTE = '727'
WHERE ID_CLIENTE = '6';


-- VERIFICAR SE HÁ REGISTROS DUPLICADO
SELECT
ID_CLIENTE AS 'IDENTIFICAÇÃO',
NOME_USUARIO AS 'CLIENTE',
ENDERECO_CLIENTE AS 'RUA',
BAIRRO_CLIENTE AS 'BAIRRO',
NUMERO_CLIENTE AS 'Nº',
COUNT(*)
FROM USUARIOS
INNER JOIN CLIENTES
ON USUARIOS.ID = CLIENTES.ID_USUARIO
INNER JOIN ENDERECOS
ON CLIENTES.ID = ENDERECOS.ID_CLIENTE
GROUP BY ID_CLIENTE, NOME_USUARIO, ENDERECO_CLIENTE, BAIRRO_CLIENTE, NUMERO_CLIENTE
HAVING COUNT(*) > 1;

-- SELECIONAR INFORMAÇÕES COMPLETA DO CLIENTE
SELECT
	ID_CLIENTE AS "CLIENTE",
	NOME_USUARIO AS "NOME DO CLIENTE",
	-- DATA_NASC_CLIENTE AS "DATA DE NASCIMENTO",
    ENDERECO_CLIENTE AS "RUA",
    BAIRRO_CLIENTE AS "BAIRRO",
    NUMERO_CLIENTE AS "Nº"
FROM USUARIOS
INNER JOIN CLIENTES
ON USUARIOS.ID = CLIENTES.ID_USUARIO
INNER JOIN ENDERECOS
ON ENDERECOS.ID_CLIENTE = CLIENTES.ID;

-- 3- REMOVER REGISTRO DE ENDEREÇOS DUPLICADO
DELETE
	FROM ENDERECOS
WHERE ID_CLIENTE IN (7);


-- SELECIONAR TODOS ADMINISTRADORES
SELECT
	* 
FROM USUARIOS 
WHERE IS_ADMIN = TRUE;
    

-- SELECIONADO OS CLIENTES PARA SABER O PRODUTO, PREÇO E O CARTÃO USADO PARA EFETUAR A COMPRA
SELECT
NOME_USUARIO AS 'CLIENTE',
NOME_PRODUTO AS 'PRODUTO',
PRECO_PRODUTO AS 'PREÇO',
TITULAR_CARTAO AS 'TITULAR DO CARTAO',
NUMERO_CARTAO AS 'NUMERO DO CARTÃO',
BANDEIRA AS 'BANDEIRA DO CARTAO'
FROM VENDAS
INNER JOIN VENDAS_PRODUTOS
ON VENDAS.ID = VENDAS_PRODUTOS.ID_VENDA
INNER JOIN PRODUTOS
ON VENDAS_PRODUTOS.ID_PRODUTO = PRODUTOS.ID
INNER JOIN VENDAS_CARTOES
ON VENDAS_CARTOES.ID_VENDA = VENDAS.ID
INNER JOIN CARTOES
ON CARTOES.ID = VENDAS_CARTOES.ID_CARTAO
INNER JOIN USUARIOS
ON USUARIOS.ID = VENDAS.ID_USUARIO;


-- VIEWS -> BUSCAR PELOS CLIENTES CADASTRADO E SUAS RESPECTIVAS COMPRAS COMO TAMBEM DATA E HORA
-- CRIANDO A VIEW
CREATE VIEW HISTORICO_COMPRA AS 
	SELECT 
		NOME_USUARIO AS 'CLIENTE',
		DATA_VENDA AS 'DATA DA COMPRA',
		NOME_PRODUTO AS 'PRODUTO'
	FROM USUARIOS
	INNER JOIN VENDAS
	ON USUARIOS.ID = VENDAS.ID_USUARIO
	INNER JOIN VENDAS_PRODUTOS
	ON VENDAS.ID = VENDAS_PRODUTOS.ID_VENDA
	INNER JOIN PRODUTOS
	ON VENDAS_PRODUTOS.ID_PRODUTO = PRODUTOS.ID;

-- BUSCANDO INFORMAÇÕES DA VIEW
SELECT * FROM HISTORICO_COMPRA;

-- BUSCAR CLIENTES QUE FAZEM ANIVERSARIO NO MES ATUAL 

CREATE VIEW CLIENTES_ANIVERSARIOS AS
	SELECT
		NOME_USUARIO AS 'CLIENTE',
		month(DATA_NASC_CLIENTE) AS 'MES DE NASCIMENTO'
	FROM USUARIOS
    INNER JOIN CLIENTES
    ON USUARIOS.ID = CLIENTES.ID_USUARIO
	WHERE month(DATA_NASC_CLIENTE) = month(curdate());
    
SELECT * FROM CLIENTES_ANIVERSARIOS;

SELECT 
USUARIOS.*,
CLIENTES.*,
ENDERECOS.*
FROM USUARIOS
LEFT JOIN CLIENTES
ON USUARIOS.ID = CLIENTES.ID_USUARIO
LEFT JOIN ENDERECOS
ON ENDERECOS.ID_CLIENTE = CLIENTES.ID;


-- CRIAR UMA PROCEDURES QUE RETORNAM A IDADE DOS CLIENTES
-- DELIMITADOR FINAL
DELIMITER $$
CREATE PROCEDURE IDADE(IN IDCLIENTE INT, OUT IDADE INT, OUT RES VARCHAR(20))
BEGIN
	
    DECLARE DT DATETIME;
    
    SET DT = (SELECT DATA_NASC_CLIENTE FROM CLIENTES WHERE ID = IDCLIENTE);
    
    SET IDADE = YEAR(NOW()) - YEAR(DT);
    
    IF(IDADE >= 32)THEN
		SET RES = TRUE;
	ELSE
		SET RES = FALSE;
	END IF;
    
    
END $$
DELIMITER ;
-- DEMILITADOR PADRÃO

-- CHAMAR A PROCEDURE
CALL IDADE(1, @IDADE_CLIENTE , @RES);
SELECT @IDADE_CLIENTE AS 'IDADE DO CLIENTE', @RES AS 'MAIORIDADE';

-- validar se ja existe registro cadastrado, se nao, ele cadastra

-- PROCEDURE PARA DAR BAIXA NA QUANTIDADE DE ESTOQUE SEMPRE QUANDO HÁ VENDA
DELIMITER $$
CREATE PROCEDURE PRODUTO_BAIXAESTOQUE(IN NCODIGO INT, IN NQUANTIDADE INT)
BEGIN
	
	UPDATE produtos
	SET QUANTIDADE_PRODUTO = QUANTIDADE_PRODUTO - NQUANTIDADE
	WHERE ID = NCODIGO;
    
END $$
DELIMITER ;

CALL PRODUTO_BAIXAESTOQUE(1,7);
SELECT * FROM PRODUTOS WHERE ID = 2;


