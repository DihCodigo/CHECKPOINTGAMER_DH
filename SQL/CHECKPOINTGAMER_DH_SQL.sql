-- SQL
-- 1- EXIBIR TODOS OS DADOS DA TABELA CLIENTES
SELECT * FROM USUARIOS;

SELECT 
	USUARIOS.ID,
	NOME_USUARIO, 
	INFORMACOES.* 
FROM INFORMACOES 
INNER JOIN USUARIOS 
ON USUARIOS.ID = INFORMACOES.ID_USUARIO;

SELECT
	USUARIOS.ID, 
	NOME_USUARIO, 
	ENDERECOS.* 
FROM ENDERECOS 
INNER JOIN USUARIOS 
ON USUARIOS.ID = ENDERECOS.ID_USUARIO;

-- 1.1- INSERIR CLIENTE NO SISTEMA
INSERT INTO USUARIOS(ID, NOME_USUARIO, EMAIL_USUARIO, SENHA_USUARIO, IS_ADMIN)
VALUES
(NULL, 'JORGE COUTINHO', 'JORJAO@GMAIL.COM', md5('A2223A4'), 0);

INSERT INTO INFORMACOES (ID, ID_USUARIO, DATA_NASC_USUARIO, CPF_USUARIO, FONE1_USUARIO, FONE2_USUARIO)
VALUES
(NULL, '6', '1991-12-28', '987-710-221-30', '(12)98921-1890', NULL);

INSERT INTO ENDERECOS (ID, ID_USUARIO, ENDERECO_USUARIO, BAIRRO_USUARIO, NUMERO_USUARIO, CIDADE_USUARIO, ESTADO_USUARIO)
VALUES
(NULL, '6', 'RUA ALFREDO TEXEIRA MACHADO', 'VILA REGINA CELIA', '232', 'CRUZEIRO', 'SÃO PAULO');


--  2- ATUALIZAR DADOS CADASTRADOS -> ATUALIZAR TROCA DE ENDEREÇO
UPDATE ENDERECOS 
SET ENDERECO_USUARIO = 'RUA SETE DE SETEMBRO', BAIRRO_USUARIO = 'CENTRO', NUMERO_USUARIO = '727'
WHERE ID_USUARIO = '6';

-- 3 - SELECIONAR INFORMAÇÕES DE ENDEREÇO COMPLETA DO CLIENTE
SELECT
	USUARIOS.ID AS "IDENT",
	NOME_USUARIO AS "CLIENTE",
    ENDERECO_USUARIO AS "RUA",
    BAIRRO_USUARIO AS "BAIRRO",
    NUMERO_USUARIO AS "Nº"
FROM USUARIOS
INNER JOIN INFORMACOES
ON USUARIOS.ID = INFORMACOES.ID_USUARIO
INNER JOIN ENDERECOS
ON ENDERECOS.ID_USUARIO = USUARIOS.ID;


-- 4- VERIFICAR SE HÁ REGISTROS DUPLICADO NA PARTE DE ENDEREÇOS
SELECT
USUARIOS.ID AS 'IDENT',
NOME_USUARIO AS 'CLIENTE',
ENDERECO_USUARIO AS 'RUA',
BAIRRO_USUARIO AS 'BAIRRO',
NUMERO_USUARIO AS 'Nº',
COUNT(*)
FROM USUARIOS
INNER JOIN INFORMACOES
ON USUARIOS.ID = INFORMACOES.ID_USUARIO
INNER JOIN ENDERECOS
ON INFORMACOES.ID = ENDERECOS.ID_USUARIO
GROUP BY USUARIOS.ID, NOME_USUARIO, ENDERECO_USUARIO, BAIRRO_USUARIO, NUMERO_USUARIO
HAVING COUNT(*) > 1;

SELECT * FROM ENDERECOS WHERE ENDERECO_USUARIO = 'RUA EURICO PEREIRA DA SILVA';
-- ------

-- 5- REMOVER REGISTRO DE ENDEREÇOS DUPLICADO
DELETE
	FROM ENDERECOS
WHERE ID IN (4);


-- 6 -SELECIONADO OS CLIENTES PARA SABER O PRODUTO, PREÇO E O CARTÃO USADO PARA EFETUAR A COMPRA
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

-- 7 - SELECINAR OS PRODUTOS COM SUAS RESPECTIVAS CATEGORIAS
SELECT
	NOME_PRODUTO AS 'PRODUTO',
    NOME_CATEGORIA AS 'CATEGORIA'
FROM PRODUTOS
INNER JOIN PRODUTOS_CATEGORIAS
ON PRODUTOS.ID = PRODUTOS_CATEGORIAS.ID_PRODUTO
INNER JOIN CATEGORIAS
ON PRODUTOS_CATEGORIAS.ID_CATEGORIA = CATEGORIAS.ID;


