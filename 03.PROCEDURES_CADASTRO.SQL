-- INIT
-- Ao iniciar pela primeira vez, será necessário preencher as tabelas de cadastro principais

-- CADASTRO EMPRESA
-- ------

-- EMPRESA - INSERIR 
CREATE OR REPLACE FUNCTION insert_into_cadempresa(cnpj VARCHAR(50), razao_social VARCHAR(155), nome_fantasia VARCHAR(155))
RETURNS VOID AS $$
BEGIN
    INSERT INTO CADEmpresa VALUES (DEFAULT, cnpj, razao_social, nome_fantasia);
END;
$$ LANGUAGE plpgsql;

-- EMPRESA - SELECIONAR TODOS
CREATE OR REPLACE FUNCTION select_all_cadempresa()
RETURNS setof CADEmpresa AS $$
BEGIN
    RETURN QUERY SELECT * FROM CADEmpresa;
END;
$$ LANGUAGE plpgsql;

-- EMPRESA - SELECIONAR POR ID
CREATE OR REPLACE FUNCTION select_id_cadempresa(id INT)
RETURNS setof CADEmpresa AS $$
BEGIN
    RETURN QUERY SELECT * FROM CADEmpresa WHERE id_empresa = id;
END;
$$ LANGUAGE plpgsql;

-- EMPRESA - ATUALIZAR POR ID
CREATE OR REPLACE FUNCTION update_cadempresa(id INT, new_cnpj VARCHAR(50), new_razao_social VARCHAR(155), new_nome_fantasia VARCHAR(155))
RETURNS VOID AS $$
BEGIN
    UPDATE CADEmpresa
    SET cnpj = new_cnpj, razao_social = new_razao_social, nome_fantasia = new_nome_fantasia
    WHERE id_empresa = id;
END;
$$ LANGUAGE plpgsql;

-- EMPRESA - DELETAR POR ID
CREATE OR REPLACE FUNCTION delete_from_cadempresa(id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM CADEmpresa WHERE id = id;
END;
$$ LANGUAGE plpgsql;


-- CONTA - INSERIR 
CREATE OR REPLACE FUNCTION insert_into_cadconta(id_conta VARCHAR(20), nome_conta VARCHAR(20), tipo_conta CHAR(1), ordem VARCHAR(10))
RETURNS VOID AS $$
BEGIN
    INSERT INTO CADConta VALUES (id_conta, nome_conta, tipo_conta, ordem);
END;
$$ LANGUAGE plpgsql;


-- ESTOQUE - INSERIR 
CREATE OR REPLACE FUNCTION insert_into_cadestoque(id_estoque VARCHAR(20), id_empresa NUMERIC(10), nome_estoque VARCHAR(20))
RETURNS VOID AS $$
BEGIN
    INSERT INTO CADEstoque VALUES (id_estoque, id_empresa, nome_estoque);
END;
$$ LANGUAGE plpgsql;

-- ITEM - INSERIR 
CREATE OR REPLACE FUNCTION insert_into_caditem(id_item VARCHAR(20), nome_item VARCHAR(50))
RETURNS VOID AS $$
BEGIN
    INSERT INTO CADItem VALUES (id_item, nome_item);
END;
$$ LANGUAGE plpgsql;

-- ITEM - SELECIONAR TODOS
CREATE OR REPLACE FUNCTION select_all_caditem()
RETURNS setof CADItem AS $$
BEGIN
    RETURN QUERY SELECT * FROM CADItem;
END;
$$ LANGUAGE plpgsql;

-- ITEM - SELECIONAR POR ID
CREATE OR REPLACE FUNCTION select_id_caditem(id VARCHAR(20))
RETURNS setof CADItem AS $$
BEGIN
    RETURN QUERY SELECT * FROM CADItem WHERE id_item = id;
END;
$$ LANGUAGE plpgsql;

-- ITEM - DELETAR POR ID
CREATE OR REPLACE FUNCTION delete_caditem(id VARCHAR(20))
RETURNS VOID AS $$
BEGIN
    DELETE FROM CADItem WHERE id_item = id;
END;
$$ LANGUAGE plpgsql;


-- FUNCTION PARA INSERIR PARCEIRO
CREATE OR REPLACE FUNCTION insert_into_cadparceiro(id_parceiro VARCHAR(50), nome_parceiro VARCHAR(155), tipo_parceiro CHAR(1), cnpj_parceiro VARCHAR(50), cpf_parceiro VARCHAR(50))
RETURNS VOID AS $$
BEGIN
    INSERT INTO CADParceiro VALUES (id_parceiro, nome_parceiro, tipo_parceiro, cnpj_parceiro, cpf_parceiro);
END;
$$ LANGUAGE plpgsql;

