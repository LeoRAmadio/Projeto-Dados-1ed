# Projeto-Dados-1ed

## Descricao do projeto :book:
Este projeto tem como objetivo simular o trabalho de uma equipe de dados em um banco digital nacional, o Alura Cash. A principal missão é desenvolver uma solução para reduzir as perdas financeiras causadas por clientes que não quitam suas dívidas dentro do prazo estipulado.

Para isso, será realizada uma análise preditiva, utilizando técnicas de ciência de dados e Machine Learning, com o objetivo de prever a probabilidade de inadimplência de um cliente antes da concessão do crédito. A partir dos dados fornecidos pelo banco, que incluem informações pessoais, histórico financeiro e detalhes sobre os empréstimos solicitados, construiremos um modelo capaz de identificar padrões e auxiliar na tomada de decisões mais seguras.

## Desenvolvimento :muscle:

### Semana 1 - Tratamento de Dados: Entendendo Como Tratar Dados com SQL
Nesta etapa inicial, o foco foi a importação, exploração e limpeza dos dados utilizando SQL. As principais atividades desenvolvidas foram:

1. **Importação do arquivo dump para o MySQL**

2. **Exploração inicial dos dados:**

    * Identificação das tabelas e seus atributos

    * Análise dos tipos de dados

    * Verificação de inconsistências e valores nulos

3. **Correção de inconsistências e transformação de dados:**

    * Conversão de tipos inadequados

    * Remoção de valores inconsistentes e duplicados


4. **Criação de relações entre tabelas:**

    * Definição de chaves primárias e estrangeiras

    * União de tabelas através de JOINs

5. **Exportação dos dados tratados para CSV para posterior uso em Machine Learning.**

O banco de dados denominado analise_risco contém as seguintes tabelas principais:

* dados_mutuarios: Contém informações pessoais dos solicitantes
* emprestimos: Dados sobre os empréstimos solicitados
* historicos_banco: Informações sobre o histórico de empréstimo de cada cliente
* ids: Relaciona os identificadores de cada informação da pessoa solicitante

### Semana 2 - Aprendendo com os dados: criando um modelo de previsão de inadimplência
Nesta etapa do projeto, o foco foi a preparação dos dados e a aplicação de modelos preditivos para prever a inadimplência dos clientes do Alura Cash.

**Principais tarefas executadas:**

1. **Importação e tradução dos dados:**
    * O conjunto de dados foi importado do MySQL e os nomes das colunas e valores categóricos foram traduzidos para português, garantindo maior clareza na análise.

2. **Análise exploratória e limpeza:**
    * Foi realizada uma verificação de dados nulos (não encontrados) e um tratamento cuidadoso dos outliers em variáveis como salário, tempo de trabalho e percentual do empréstimo em relação à renda. Clientes com renda muito alta e que nunca haviam sido inadimplentes foram removidos para evitar viés no modelo.

3. **Codificação de variáveis categóricas:**
   * Foi aplicado o OneHotEncoder para transformar variáveis categóricas, como situação de moradia e motivo do empréstimo, permitindo que o modelo utilize essas informações.

4. **Análise de correlação:**
   * Foi analisada a relação entre as variáveis para entender melhor os fatores que influenciam a inadimplência.

5. **Balanceamento da variável alvo:**
   * A base de dados original apresentava um desbalanceamento entre clientes inadimplentes e adimplentes. Para corrigir isso, utilizou-se a técnica SMOTE, que gera novos exemplos sintéticos da classe minoritária, garantindo que o modelo aprenda de maneira mais equilibrada.

6. **Normalização dos dados:**
   * Aplicou-se StandardScaler para padronizar as variáveis numéricas, melhorando o desempenho dos algoritmos de Machine Learning.

7. **Treinamento dos modelos:**
   * Foram testados dois algoritmos para previsão da inadimplência: Máquina de Vetores de Suporte (SVC) e Árvore de Decisão (DecisionTreeClassifier). Ambos os modelos foram treinados e avaliados quanto à acurácia, buscando a melhor abordagem para identificar clientes inadimplentes com precisão.

8. **Exportação dos modelos:**
   * Os modelos treinados, bem como os processos de codificação e normalização, foram salvos utilizando a biblioteca joblib, permitindo sua reutilização em futuras previsões.

Assim, a base de dados está preparada e os primeiros modelos foram avaliados, estabelecendo uma base sólida para refinamentos futuros.

### Semana 3: Analisando métricas: criando visualizações com o Power BI (Em desenvolvimento :construction_worker:)
   





































