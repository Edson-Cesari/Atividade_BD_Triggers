--CRIANDO TODAS AS TABELAS--
CREATE TABLE produto(
  id serial PRIMARY Key,
  descricao VARCHAR(100) NOT NULL,
  valor NUMERIC(5,2)
);

CREATE TABLE cliente(
  id serial PRIMARY KEY,
  nome VARCHAR(30) NOT NULL,
  email VARCHAR(30) NOT NULL
);

create table cliente_produto(
  fk_id_cliente INT,
  fk_id_produto INT,
  quantidade int,
  valor_total NUMERIC(5,2),
  CONSTRAINT fk_id_cliente FOREIGN key(fk_id_cliente) REFERENCES cliente(id),
  CONSTRAINT fk_id_produto FOREIGN key(fk_id_produto) REFERENCES produto(id),
  CONSTRAINT pk_cliente_produto PRIMARY KEY(fk_id_cliente,fk_id_produto)
);

CREATE TABLE log_produto(
  id serial PRIMARY KEY,
  operacao VARCHAR(20),
  id_operacao int,
  produto_operacao VARCHAR(50),
  data_hora_operacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--INSERINDO DADOS EM TODAS AS TABELAS--
INSERT INTO cliente(nome,email) VALUES
('Chaves','chaves8@gmail.com.mx'),
('Seu Madruga','domramon@gmail.com.mx'),
('Dona Florinda','florindameza@gmail.com'),
('Quico','frederico@gmail.com'),
('Bruxa 71','clotilde@gmail.com'),
('Chiquinha','fransiquinha@gmail.com'),
('Nhonho','nhohno@gmail.com');

select * from cliente;

INSERT into produto(descricao,valor) VALUES
('Bola Quadrada',20.50),
('Zarabatana e chumbinho',3.50),
('Pirulito da vanda da esquina',1.00),
('Farinha para churos',2.50),
('Album de figurinhas',5.00),
('Varinha magica',1.50),
('Cola de sapateiro',2.00),
('Chapeu e roupas usadas',10.00),
('Bola de boliche',35.50),
('Suco de limao, que é de groselha e parece tamarindo',1.50),
('Sanduiche de presunto',1.50),
('14 ovos e 32 sucos de frutas',45.50),
('carambola',1.00),
('Bilhete de loteria',2.50),
('panqueca',2.00);

SELECT * from cliente;

--CRIANDO UMA FUNÇÃO PARA INSERIR INFORMAÇÃO NA TABELA log_produto--
CREATE or REPLACE FUNCTION monitorar_produto() RETURNS
TRIGGER as $$
BEGIN
    	INSERT into log_produto(id_operacao, produto_operacao ,operacao) values
        (new.id, new.descricao,'Dados inseridos.');
    RETURN NULL;
end;
$$ LANGUAGE plpgsql;


--CRIANDO UMA TRIGGER PARA MONITORAR OPERACOES NA TABELA produto--
CREATE TRIGGER checando_operacoes_produto
AFTER insert on produto 
FOR EACH ROW 
EXECUTE PROCEDURE monitorar_produto();

--TESTANDO A TRIGGER--
insert into produto(descricao,valor) VALUES
('Vassoura',10.00);

--VERIFICANDO O FUNCIONAMENTO DA TRIGGER--
SELECT * from log_produto;