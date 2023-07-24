-- DROP TABLES
DROP TABLE TRAReconLinhas;
DROP TABLE TRAReconciliacao;
DROP TABLE TRAEstoque;
DROP TABLE TRAFinanceiraLinha;
DROP TABLE TRAFinanceira;
DROP TABLE DOCRecebimentoLinha;
DROP TABLE DOCRecebimento;
DROP TABLE DOCSaidaLinha;
DROP TABLE DOCSaida;
DROP TABLE DOCPagamentoLinha;
DROP TABLE DOCPagamento;
DROP TABLE DOCEntradaLinha;
DROP TABLE DOCEntrada;
DROP TABLE CADParceiro;
DROP TABLE CADItem;
DROP TABLE CADEstoque;
DROP TABLE CADConta;
DROP TABLE CADEmpresa;
DROP TABLE CADUser;

-- Criação das tabelas de cadastro
-- ------
-- Criação da tabela CADUser
CREATE TABLE CADUser (
    id_user     VARCHAR(10) PRIMARY KEY,
    login       VARCHAR(10) UNIQUE,
    senha       VARCHAR(10),
    nome        VARCHAR(50)
);

-- Criação da tabela CADEmpresa
CREATE TABLE CADEmpresa (
    id_empresa      NUMERIC(10) PRIMARY KEY,
    cnpj_empresa    VARCHAR(50) UNIQUE,
    razao_social    VARCHAR(155) UNIQUE,
    nome_fantasia   VARCHAR(155)
);

-- Criação da tabela CADConta
CREATE TABLE CADConta (
    id_conta    VARCHAR(20) PRIMARY KEY,
    nome_conta  VARCHAR(20),
    tipo_conta  CHAR(1),
    ordem       VARCHAR(10),
    CONSTRAINT  ck_tipoConta_CADConta CHECK (tipo_conta IN('A','P', 'L','R','D'))
);

-- Criação da tabela CADEstoque
CREATE TABLE CADEstoque (
    id_estoque      VARCHAR(20) PRIMARY KEY,
    id_empresa      NUMERIC(10),
    nome_estoque    VARCHAR(20) UNIQUE,
    CONSTRAINT      fk_CADEmpresa_CADEstoque FOREIGN KEY (id_empresa) REFERENCES CADEmpresa(id_empresa)
);

-- Criação da tabela CADItem
CREATE TABLE CADItem (
    id_item     VARCHAR(20) PRIMARY KEY,
    nome_item   VARCHAR(50) UNIQUE
);

-- Criação da tabela CADParceiro
CREATE TABLE CADParceiro (
    id_parceiro     VARCHAR(50) PRIMARY KEY,
    nome_parceiro   VARCHAR(155) UNIQUE,
    tipo_parceiro   CHAR(1),
    cnpj_parceiro   VARCHAR(50),
    cpf_parceiro    VARCHAR(50),
    -- F: Fornecedor; C: Cliente; L: Lead
    CONSTRAINT      ck_tipoParceiro_CADParceiro CHECK (tipo_parceiro IN('F','C', 'L'))
);

-- Criação das tabelas de documentos
-- ------
-- Criação da tabela DOCEntrada
CREATE TABLE DOCEntrada(
    id_doc      NUMERIC(10) PRIMARY KEY,
    id_empresa  NUMERIC(10),
    id_parceiro VARCHAR(50),
    id_user     VARCHAR(10),
    tipo_doc    CHAR(1),
    data_doc    DATE,
    data_venc   DATE,
    CONSTRAINT  fk_CADEmpresa_DOCEntrada    FOREIGN KEY (id_empresa)    REFERENCES CADEmpresa(id_empresa),
    CONSTRAINT  fk_CADParceiro_DOCEntrada   FOREIGN KEY (id_parceiro)   REFERENCES CADParceiro(id_parceiro),
    CONSTRAINT  fk_CADUser_DOCEntrada       FOREIGN KEY (id_user)       REFERENCES CADUser(id_user),
    CONSTRAINT  ck_tipoDoc_DOCEntrada       CHECK (tipo_doc IN('E'))
);

-- Criação da tabela DOCEntradaLinha
CREATE TABLE DOCEntradaLinha(
    id_doc      NUMERIC(10),
    id_item     VARCHAR(20),
    id_conta    VARCHAR(20),
    id_estoque  VARCHAR(20),
    quantidade  NUMERIC(10),
    valor_un    NUMERIC(19,6),
    num_linha   NUMERIC(10),
    CONSTRAINT  fk_DOCEntrada_DOCEntradaLinha   FOREIGN KEY (id_doc)        REFERENCES DOCEntrada(id_doc),
    CONSTRAINT  fk_CADItem_DOCEntradaLinha      FOREIGN KEY (id_item)       REFERENCES CADItem(id_item),
    CONSTRAINT  fk_CADConta_DOCEntradaLinha     FOREIGN KEY (id_conta)      REFERENCES CADConta(id_conta),
    CONSTRAINT  fk_CADEstoque_DOCEntradaLinha   FOREIGN KEY (id_estoque)    REFERENCES CADEstoque(id_estoque)
);


-- Criação da tabela DOCPagamento
CREATE TABLE DOCPagamento(
    id_doc      NUMERIC(10) PRIMARY KEY,
    id_empresa  NUMERIC(10),
    id_parceiro VARCHAR(50),
    id_user     VARCHAR(10),
    tipo_doc    CHAR(1),
    data_doc    DATE,
    data_venc   DATE,
    CONSTRAINT  fk_CADEmpresa_DOCPagamento  FOREIGN KEY (id_empresa)    REFERENCES CADEmpresa(id_empresa),
    CONSTRAINT  fk_CADParceiro_DOCPagamento FOREIGN KEY (id_parceiro)   REFERENCES CADParceiro(id_parceiro),
    CONSTRAINT  fk_CADUser_DOCPagamento     FOREIGN KEY (id_user)       REFERENCES CADUser(id_user),
    CONSTRAINT  ck_tipoDoc_DOCPagamento     CHECK (tipo_doc IN('P'))
);


-- Criação da tabela DOCPagamentoLinha
CREATE TABLE DOCPagamentoLinha(
    id_doc      NUMERIC(10),
    id_conta    VARCHAR(20),
    tipo_doc    CHAR(1),
    id_doc_pag  NUMERIC(10),
    valor       NUMERIC(19,6),
    num_linha   NUMERIC(10),
    CONSTRAINT  fk_DOCPagamento_DOCPagamentoLinha   FOREIGN KEY (id_doc)    REFERENCES DOCPagamento(id_doc),
    CONSTRAINT  fk_CADConta_DOCPagamentoLinha       FOREIGN KEY (id_conta)  REFERENCES CADConta(id_conta),
    CONSTRAINT  ck_tipoDoc_DOCPagamentoLinha        CHECK (tipo_doc IN('E', 'S', 'L'))
);

-- Criação da tabela DOCSaida
CREATE TABLE DOCSaida(
    id_doc      NUMERIC(10) PRIMARY KEY,
    id_empresa  NUMERIC(10),
    id_parceiro VARCHAR(50),
    id_user     VARCHAR(10),
    tipo_doc    CHAR(1),
    data_doc    DATE,
    data_venc   DATE,
    CONSTRAINT  fk_CADEmpresa_DOCSaida  FOREIGN KEY (id_empresa)    REFERENCES CADEmpresa(id_empresa),
    CONSTRAINT  fk_CADParceiro_DOCSaida FOREIGN KEY (id_parceiro)   REFERENCES CADParceiro(id_parceiro),
    CONSTRAINT  fk_CADUser_DOCSaida     FOREIGN KEY (id_user)       REFERENCES CADUser(id_user),
    CONSTRAINT  ck_tipoDoc_DOCSaida     CHECK (tipo_doc IN('S'))
);

-- Criação da tabela DOCSaidaLinha
CREATE TABLE DOCSaidaLinha(
    id_doc      NUMERIC(10),
    id_item     VARCHAR(20),
    id_conta    VARCHAR(20),
    id_estoque  VARCHAR(20),
    quantidade  NUMERIC(10),
    valor_un    NUMERIC(19,6),
    num_linha   NUMERIC(10),
    CONSTRAINT  fk_DOCEntrada_DOCSaidaLinha FOREIGN KEY (id_doc)        REFERENCES DOCEntrada(id_doc),
    CONSTRAINT  fk_CADItem_DOCSaidaLinha    FOREIGN KEY (id_item)       REFERENCES CADItem(id_item),
    CONSTRAINT  fk_CADConta_DOCSaidaLinha   FOREIGN KEY (id_conta)      REFERENCES CADConta(id_conta),
    CONSTRAINT  fk_CADEstoque_DOCSaidaLinha FOREIGN KEY (id_estoque)    REFERENCES CADEstoque(id_estoque)
);

-- Criação da tabela DOCRecebimento
CREATE TABLE DOCRecebimento(
    id_doc      NUMERIC(10) PRIMARY KEY,
    id_empresa  NUMERIC(10),
    id_parceiro VARCHAR(50),
    id_user     VARCHAR(10),
    tipo_doc    CHAR(1),
    data_doc    DATE,
    data_venc   DATE,
    CONSTRAINT  fk_CADEmpresa_DOCRecebimento    FOREIGN KEY (id_empresa)    REFERENCES CADEmpresa(id_empresa),
    CONSTRAINT  fk_CADParceiro_DOCRecebimento   FOREIGN KEY (id_parceiro)   REFERENCES CADParceiro(id_parceiro),
    CONSTRAINT  fk_CADUser_DOCRecebimento       FOREIGN KEY (id_user)       REFERENCES CADUser(id_user),
    CONSTRAINT  ck_tipoDoc_DOCRecebimento       CHECK (tipo_doc IN('R'))
);

-- Criação da tabela DOCRecebimentoLinha
CREATE TABLE DOCRecebimentoLinha(
    id_doc      NUMERIC(10),
    id_conta    VARCHAR(20),
    tipo_doc    CHAR(1),
    id_doc_pag  NUMERIC(10),
    valor       NUMERIC(19,6),
    num_linha   NUMERIC(10),
    CONSTRAINT  fk_DOCPagamento_DOCRecebimentoLinha FOREIGN KEY (id_doc)    REFERENCES DOCPagamento(id_doc),
    CONSTRAINT  fk_CADConta_DOCRecebimentoLinha     FOREIGN KEY (id_conta)  REFERENCES CADConta(id_conta),
    CONSTRAINT  ck_tipoDoc_DOCRecebimentoLinha      CHECK (tipo_doc IN('E', 'S', 'L'))
);

-- Criação das tabelas de Transação
-- ------
-- Criação da tabela TRAFinanceira
CREATE TABLE TRAFinanceira(
    id_tran     NUMERIC(10) PRIMARY KEY,
    id_doc      NUMERIC(10),
    id_empresa  NUMERIC(10),
    id_parceiro VARCHAR(10),
    id_user	    VARCHAR(10),
    tipo_tran   CHAR(1),
    data_tran   DATE,
    CONSTRAINT  fk_CADEmpresa_TRAFinanceira     FOREIGN KEY (id_empresa)    REFERENCES CADEmpresa(id_empresa),
    CONSTRAINT  fk_CADParceiro_TRAFinanceira    FOREIGN KEY (id_parceiro)   REFERENCES CADParceiro(id_parceiro),
    CONSTRAINT  fk_CADUser_TRAFinanceira        FOREIGN KEY (id_user)       REFERENCES CADUser(id_user),
    CONSTRAINT  ck_tipoTran_TRAFinanceira       CHECK (tipo_tran IN('E', 'S', 'L', 'P','R'))
);

-- Criação da tabela TRAFinanceiraLinha
CREATE TABLE TRAFinanceiraLinha(
    id_tran     NUMERIC(10),
    id_conta    VARCHAR(20),
    debcred     CHAR(1),
    debito      NUMERIC(19,6),
    credito     NUMERIC(19,6),
    num_linha   NUMERIC(10),
    CONSTRAINT  fk_TRAFinanceira_TRAFinanceiraLinha FOREIGN KEY (id_tran)   REFERENCES TRAFinanceira(id_tran),
    CONSTRAINT  fk_CADConta_TRAFinanceiraLinha      FOREIGN KEY (id_conta)  REFERENCES CADConta(id_conta),
    CONSTRAINT  ck_debcred_TRAFinanceiraLinha       CHECK (debcred IN('D','C'))
);

-- Criação da tabela TRAEstoque
CREATE TABLE TRAEstoque(
    id_tran     NUMERIC(10) PRIMARY KEY,
    id_estoque  VARCHAR(20),
    id_item     VARCHAR(20),
    entsai      CHAR(1),
    qtd_ent     NUMERIC(10),
    qtd_sai     NUMERIC(10),
    data_tran   DATE,
    CONSTRAINT  fk_CADEstoque_TRAEstoque    FOREIGN KEY (id_estoque)    REFERENCES CADEstoque(id_estoque),
    CONSTRAINT  fk_CADItem_TRAEstoque       FOREIGN KEY (id_item)       REFERENCES CADItem(id_item),
    CONSTRAINT  ck_debcred_TRAEstoque       CHECK (entsai IN('E','S'))
);

-- Criação da tabela TRAReconciliacao
CREATE TABLE TRAReconciliacao(
    id_recon    NUMERIC(10) PRIMARY KEY,
    tipo_trecon CHAR(1),
    data_recon  DATE,
    CONSTRAINT  ck_debcred_TRAReconciliacao CHECK (tipo_trecon IN('P','R'))
);

-- Criação da tabela TRAReconLinhas
CREATE TABLE TRAReconLinhas(
    id_recon    NUMERIC(10),
    id_tran     NUMERIC(10),
    id_conta    VARCHAR(20),
    debcred     CHAR(1),
    valor       NUMERIC(19,6),
    tran_linha  NUMERIC(10),
    num_linha   NUMERIC(10),
    CONSTRAINT  fk_TRAReconciliacao_TRAReconLinhas  FOREIGN KEY (id_recon)  REFERENCES TRAReconciliacao(id_recon),
    CONSTRAINT  fk_TRAFinanceira_TRAReconLinhas     FOREIGN KEY (id_tran)   REFERENCES TRAFinanceira(id_tran),
    CONSTRAINT  fk_CADConta_TRAReconLinhas          FOREIGN KEY (id_conta)  REFERENCES CADConta(id_conta),
    CONSTRAINT  ck_debcred_TRAReconLinhas           CHECK (debcred IN('P','R'))
);
