-- EXECUTAR ISSO NO BANCO
CREATE EXTENSION pgcrypto;

-- GERAR HASHES
CREATE OR REPLACE FUNCTION encrypt_password(plain_text TEXT)
RETURNS TEXT AS
$$
BEGIN
    RETURN crypt(plain_text, gen_salt('md5'));
END;
$$
LANGUAGE plpgsql;

-- COMPARAR HASHES
CREATE OR REPLACE FUNCTION compare_hashes(plain_text TEXT, hashed_text TEXT)
RETURNS BOOLEAN AS
$$
BEGIN
    RETURN hashed_text = crypt(plain_text, hashed_text);
END;
$$
LANGUAGE plpgsql;

-- CRIAR USUÁRIOS
CREATE OR REPLACE FUNCTION insert_into_caduser(login VARCHAR(10), senha TEXT, nome VARCHAR(50))
RETURNS VOID AS $$
BEGIN
    INSERT INTO CADUser VALUES (DEFAULT, login, encrypt_password(senha), nome);
END;
$$ LANGUAGE plpgsql;

-- ENTRAR USUÁRIO
CREATE OR REPLACE FUNCTION login_user(plogin VARCHAR(10), psenha TEXT)
RETURNS setof CADUser
AS $$
BEGIN
    RETURN QUERY (
        SELECT *
        FROM CADUser
        WHERE login = plogin AND compare_hashes(psenha, senha) IS TRUE
        LIMIT 1
    );
END;
$$ LANGUAGE plpgsql;

-- SELECIONAR TODOS
CREATE OR REPLACE FUNCTION select_id_caduser(id INT)
RETURNS setof CADUser AS $$
BEGIN
    RETURN QUERY SELECT * FROM CADUser WHERE id_user = id;
END;
$$ LANGUAGE plpgsql;

-- SELECIONAR TODOS
CREATE OR REPLACE FUNCTION select_all_caduser()
RETURNS setof CADUser AS $$
BEGIN
    RETURN QUERY SELECT * FROM CADUser;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_caduser(id INT, new_login VARCHAR(10), new_nome VARCHAR(50))
RETURNS VOID AS $$
BEGIN
    UPDATE CADUser
    SET login = new_login, nome = new_nome
    WHERE id_user = id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_caduser(id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM CADUser WHERE id_user = id;
END;
$$ LANGUAGE plpgsql;