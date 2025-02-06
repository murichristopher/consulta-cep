# **ConsultaCep**

Este projeto foi desenvolvido como parte do **Desafio Técnico Oficinaria**, que consiste em criar uma aplicação web de **busca por CEP** usando **Ruby on Rails** integrado com **Tailwind CSS + DaisyUI** e Turbo JS e Stimulus. A aplicação está **hospedada no Heroku** e pode ser acessada em:  
[https://consulta-cep-c0754f8e8c0d.herokuapp.com/](https://consulta-cep-c0754f8e8c0d.herokuapp.com/)

A aplicação realiza chamadas à [Awesome API de CEP](https://cep.awesomeapi.com.br/) para exibir informações de endereço, estado, cidade e outras estatísticas relacionadas aos CEPs buscados.

---

## **Tabela de Conteúdos**
0. [Screenshots](#screenshots)
1. [Funcionalidades](#funcionalidades)
2. [Bônus Implementados](#bônus-implementados)
3. [Principais Gems](#principais-gems)
4. [Como Executar](#como-executar)
5. [Testes Automatizados](#testes-automatizados)
6. [Comandos Úteis do Makefile](#comandos-úteis-do-makefile)

---

## **Screenshots** 

<img width="1454" alt="Captura de Tela 2025-02-06 às 07 21 13" src="https://github.com/user-attachments/assets/8d60f901-5739-4ea6-b5af-9e04ecacdd2f" />
<img width="1454" alt="Captura de Tela 2025-02-06 às 07 21 28" src="https://github.com/user-attachments/assets/4be25ffc-d353-40e2-9a33-04850660fb6c" />
<img width="1454" alt="Captura de Tela 2025-02-06 às 07 21 39" src="https://github.com/user-attachments/assets/1ecfdd1d-8852-42dd-a8d2-0a080670db0f" />
<img width="1454" alt="Captura de Tela 2025-02-06 às 07 21 52" src="https://github.com/user-attachments/assets/b4c3b07f-29b4-432a-93b4-3cb6f98e393a" />



## **Funcionalidades**

1. **Busca de CEP**
  - Formulário para digitar o CEP e buscar dados na API [Awesome API](https://cep.awesomeapi.com.br/).
  - Exibe na mesma página os dados retornados: endereço, bairro, cidade, estado, DDD, etc.
  - Exibe mensagens de erro caso o CEP não seja encontrado ou haja problemas na chamada externa.

2. **Exibição de CEPs Mais Buscados**
  - Lista dos CEPs ordenados por maior quantidade de buscas (“CEPs Mais Buscados”).

3. **Quantidade de CEPs por Estado**
  - Exibe quantos CEPs foram consultados por estado.

4. **CEPs Mais Buscados por Localização**
  - Lista as cidades (e estados) mais pesquisadas, com o número de buscas.

---

## **Bônus Implementados**

- **Armazenamento e Estatísticas**
  - A cada busca, incrementa a contagem de pesquisas do CEP no banco de dados.
  - Mantém estatísticas para exibir os CEPs mais buscados e estatísticas de busca por estado/cidade.

- **Integração Turbo Frames**
  - Uso de Turbo Frames para atualizar apenas a seção de busca, sem recarregar a página inteira.

- **Internacionalização**
  - Utiliza `I18n` para as strings e mensagens de erro.

---

## **Principais Gems**

- **[faraday](https://github.com/lostisland/faraday)** – Usada para fazer requisições HTTP à Awesome API.
- **[heroicon](https://github.com/bhoggard/heroicon)** – Disponibiliza ícones prontos para uso em Rails.
- **[factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails)** + **[faker](https://github.com/faker-ruby/faker)** – Facilita a criação de dados falsos (fake) para testes.
- **[rspec-rails](https://github.com/rspec/rspec-rails)** – Framework principal de testes.
- **[shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)** – Fornece matchers adicionais para testes de modelos e controllers.
- **[simplecov](https://github.com/simplecov-ruby/simplecov)** – Gera relatórios de cobertura de testes.
- **[webmock](https://github.com/bblimke/webmock)** – Permite mockar requisições HTTP nos testes.

Entre outras gems padrão do ecossistema Rails (como `bootsnap`, `dotenv-rails`, `turbo-rails`, `stimulus-rails`, etc.).

---

## **Como Executar**

### **1) Clonar Repositório**

```bash
git clone https://github.com/seu-usuario/consulta-cep.git
cd consulta-cep
```

### **2) Via Docker Compose (Recomendado)**

1. **Construir e Iniciar os Contêineres**

```bash
docker compose build
docker compose up -d
```

Isso iniciará o contêiner web (Rails) e o banco PostgreSQL.

2. **Acessar a Aplicação**

Abra [http://localhost:3000](http://localhost:3000) no navegador.

3. **Parar a Aplicação**

```bash
docker compose down
```

### **3) Execução Manual (Sem Docker)**

1. Instale Ruby (3.3.1+), PostgreSQL (16+) e Node (para assets).
2. Crie e configure o banco de dados (config/database.yml).
3. Instale as dependências:

```bash
bundle install
```

4. Configure o banco:

```bash
bin/rails db:setup
```

5. Inicie o servidor:

```bash
bin/rails server
```

6. Acesse [http://localhost:3000](http://localhost:3000).

---

## **Testes Automatizados**

Para executar a suíte de testes:

### **Dentro do Docker**

```bash
docker compose exec -e RAILS_ENV=test web bundle exec rspec
```

### **Ou localmente**

```bash
bundle exec rspec
```

São utilizados RSpec (modelos, controllers, serviços) e WebMock (mock de chamadas externas), além de factory_bot, faker e shoulda-matchers.

---

## **Comandos Úteis do Makefile**

Este projeto inclui um Makefile que facilita operações do dia a dia:
- `make start`: Inicia todos os serviços (contêiner web, PostgreSQL).
- `make stop`: Para e remove os contêineres.
- `make bash`: Abre um shell interativo dentro do contêiner web.
- `make console`: Abre o console Rails (rails c) dentro do contêiner web.
- `make tests`: Executa a suíte de testes com RSpec.
- `make logs`: Visualiza os logs de todos os serviços.
- `make clean`: Remove contêineres, imagens e volumes órfãos.

Para ver todos os comandos, rode:

```bash
make help
```

---

Feito com ☕, Rails e Tailwind CSS
