-- INIT
-- Ao iniciar pela primeira vez, será necessário preencher as tabelas de cadastro principais
-- PROCEDURE PARA INSERIR USER
CREATE PROCEDURE INSERE_USER(
    id_user VARCHAR(10),
    login   VARCHAR(10),
    senha   VARCHAR(10),
    nome    VARCHAR(50))
LANGUAGE SQL
AS $$
INSERT INTO CADUser VALUES (id_user, login, senha, nome);
$$;

-- PROCEDURE PARA INSERIR EMPRESA
CREATE PROCEDURE INSERE_EMPRESA(
    id_empresa      NUMERIC(10),
    cnpj_empresa    VARCHAR(50),
    razao_social    VARCHAR(155),
    nome_fantasia   VARCHAR(155))
LANGUAGE SQL
AS $$
INSERT INTO CADEmpresa VALUES (id_empresa, cnpj_empresa, razao_social, nome_fantasia);
$$;

-- PROCEDURE PARA INSERIR ESTOQUE
CREATE PROCEDURE INSERE_ESTOQUE(
    id_estoque      VARCHAR(20),
    id_empresa      NUMERIC(10),
    nome_estoque    VARCHAR(20))
LANGUAGE SQL
AS $$
INSERT INTO CADEstoque VALUES (id_estoque, id_empresa, nome_estoque);
$$;

-- PROCEDURE PARA INSERIR ITEM
CREATE PROCEDURE INSERE_ITEM(
    id_item     VARCHAR(20),
    nome_item   VARCHAR(50))
LANGUAGE SQL
AS $$
INSERT INTO CADItem VALUES (id_item, nome_item);
$$;

-- PROCEDURE PARA INSERIR PARCEIRO
CREATE PROCEDURE INSERE_PARCEIRO(
    id_parceiro     VARCHAR(50),
    nome_parceiro   VARCHAR(155),
    tipo_parceiro   CHAR(1),
    cnpj_parceiro   VARCHAR(50),
    cpf_parceiro    VARCHAR(50))
LANGUAGE SQL
AS $$
INSERT INTO CADParceiro VALUES (id_parceiro, nome_parceiro, tipo_parceiro, cnpj_parceiro, cpf_parceiro);
$$;

-- PROCEDURE PARA INSERIR ENTRADA
CREATE PROCEDURE INSERE_ENTRADA(
    id_doc      NUMERIC(10),
    id_empresa  NUMERIC(10),
    id_parceiro VARCHAR(50),
    id_user     VARCHAR(10),
    tipo_doc    CHAR(1),
    data_doc    DATE,
    data_venc   DATE)
LANGUAGE SQL
AS $$
INSERT INTO DOCEntrada VALUES (id_doc, id_empresa, id_parceiro, id_user, tipo_doc, data_doc, data_venc);
$$;

-- PROCEDURE PARA INSERIR ENTRADA LINHA
CREATE PROCEDURE INSERE_ENTRADA_LINHA(
    id_doc      NUMERIC(10),
    id_item     VARCHAR(20),
    id_conta    VARCHAR(20),
    id_estoque  VARCHAR(20),
    quantidade  NUMERIC(10),
    valor_un    NUMERIC(19,6),
    num_linha   NUMERIC(10))
LANGUAGE SQL
AS $$
INSERT INTO DOCEntradaLinha VALUES (id_doc, id_item, id_conta, id_estoque, quantidade, valor_un, num_linha);
$$;

-- PROCEDURE PARA INSERIR PAGAMENTO
CREATE PROCEDURE INSERE_PAGAMENTO(
    id_doc      NUMERIC(10),
    id_empresa  NUMERIC(10),
    id_parceiro VARCHAR(50),
    id_user     VARCHAR(10),
    tipo_doc    CHAR(1),
    data_doc    DATE,
    data_venc   DATE)
LANGUAGE SQL
AS $$
INSERT INTO DOCPagamento VALUES (id_doc, id_empresa, id_parceiro, id_user, tipo_doc, data_doc, data_venc);
$$;

-- PROCEDURE PARA INSERIR PAGAMENTO LINHA
CREATE PROCEDURE INSERE_PAGAMENTO_LINHA(
    id_doc      NUMERIC(10),
    id_conta    VARCHAR(20),
    tipo_doc    CHAR(1),
    id_doc_pag  NUMERIC(10),
    valor       NUMERIC(19,6),
    num_linha   NUMERIC(10))
LANGUAGE SQL
AS $$
INSERT INTO DOCPagamentoLinha VALUES (id_doc, id_conta, tipo_doc, id_doc_pag, valor, num_linha);
$$;

-- PROCEDURE PARA INSERIR SAIDA
CREATE PROCEDURE INSERE_SAIDA(
    id_doc      NUMERIC(10),
    id_empresa  NUMERIC(10),
    id_parceiro VARCHAR(50),
    id_user     VARCHAR(10),
    tipo_doc    CHAR(1),
    data_doc    DATE,
    data_venc   DATE)
LANGUAGE SQL
AS $$
INSERT INTO DOCSaida VALUES (id_doc, id_empresa, id_parceiro, id_user, tipo_doc, data_doc, data_venc);
$$;

-- PROCEDURE PARA INSERIR SAIDA LINHA
CREATE PROCEDURE INSERE_SAIDA_LINHA(
    id_doc      NUMERIC(10),
    id_item     VARCHAR(20),
    id_conta    VARCHAR(20),
    id_estoque  VARCHAR(20),
    quantidade  NUMERIC(10),
    valor_un    NUMERIC(19,6),
    num_linha   NUMERIC(10))
LANGUAGE SQL
AS $$
INSERT INTO DOCSaidaLinha VALUES (id_doc, id_item, id_conta, id_estoque, quantidade, valor_un, num_linha);
$$;

-- PROCEDURE PARA INSERIR RECEBIMENTO
CREATE PROCEDURE INSERE_RECEBIMENTO(
    id_doc      NUMERIC(10),
    id_empresa  NUMERIC(10),
    id_parceiro VARCHAR(50),
    id_user     VARCHAR(10),
    tipo_doc    CHAR(1),
    data_doc    DATE,
    data_venc   DATE)
LANGUAGE SQL
AS $$
INSERT INTO DOCRecebimento VALUES (id_doc, id_empresa, id_parceiro, id_user, tipo_doc, data_doc, data_venc);
$$;

-- PROCEDURE PARA INSERIR RECEBIMENTO LINHA
CREATE PROCEDURE INSERE_RECEBIMENTO_LINHA(
    id_doc      NUMERIC(10),
    id_conta    VARCHAR(20),
    tipo_doc    CHAR(1),
    id_doc_pag  NUMERIC(10),
    valor       NUMERIC(19,6),
    num_linha   NUMERIC(10))
LANGUAGE SQL
AS $$
INSERT INTO DOCRecebimentoLinha VALUES (id_doc, id_conta, tipo_doc, id_doc_pag, valor, num_linha);
$$;

-- PROCEDURE PARA INSERIR TRANSACAO FINANCEIRA
CREATE PROCEDURE INSERE_TRAN_FINANC(
    id_tran     NUMERIC(10),
    id_doc      NUMERIC(10),
    id_empresa  NUMERIC(10),
    id_parceiro VARCHAR(10),
    id_user	    VARCHAR(10),
    tipo_tran   CHAR(1),
    data_tran   DATE)
LANGUAGE SQL
AS $$
INSERT INTO TRAFinanceira VALUES (id_tran, id_doc, id_empresa, id_parceiro, id_user, tipo_tran, data_tran);
$$;

-- PROCEDURE PARA INSERIR TRANSACAO FINANCEIRA LINHA
CREATE PROCEDURE INSERE_TRAN_FINANC_LINHA(
    id_tran     NUMERIC(10),
    id_conta    VARCHAR(20),
    debcred     CHAR(1),
    debito      NUMERIC(19,6),
    credito     NUMERIC(19,6),
    num_linha   NUMERIC(10))
LANGUAGE SQL
AS $$
INSERT INTO TRAFinanceiraLinha VALUES (id_tran, id_conta, debcred, debito, credito, num_linha);
$$;

-- PROCEDURE PARA INSERIR TRANSACAO DE ESTOQUE
CREATE PROCEDURE INSERE_TRA_ESTOQUE(
    id_tran     NUMERIC(10),
    id_estoque  VARCHAR(20),
    id_item     VARCHAR(20),
    entsai      CHAR(1),
    qtd_ent     NUMERIC(10),
    qtd_sai     NUMERIC(10),
    data_tran   DATE)
LANGUAGE SQL
AS $$
INSERT INTO TRAEstoque VALUES (id_tran, id_estoque, id_item, entsai, qtd_ent, qtd_sai, data_tran);
$$;

-- PROCEDURE PARA INSERIR RECONCILIAÇÃO
CREATE PROCEDURE INSERE_TRA_RECON(
    id_recon    NUMERIC(10),
    tipo_trecon CHAR(1),
    data_recon  DATE)
LANGUAGE SQL
AS $$
INSERT INTO TRAReconciliacao VALUES (id_recon, tipo_trecon, data_recon);
$$;

-- PROCEDURE PARA INSERIR RECONCILIAÇÃO LINHA
CREATE PROCEDURE INSERE_TRA_RECON_LINHAS(
    id_recon    NUMERIC(10),
    id_tran     NUMERIC(10),
    id_conta    VARCHAR(20),
    debcred     CHAR(1),
    valor       NUMERIC(19,6),
    tran_linha  NUMERIC(10),
    num_linha   NUMERIC(10))
LANGUAGE SQL
AS $$
INSERT INTO TRAReconLinhas VALUES (id_recon, id_tran, id_conta, debcred, valor, tran_linha, num_linha);
$$;

