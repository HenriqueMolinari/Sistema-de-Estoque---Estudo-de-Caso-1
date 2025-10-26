# 🚀 Sistema de Gestão de Produtos e Fornecedores

Um sistema completo desenvolvido em Dart com conceitos de Programação Orientada a Objetos (POO) para gerenciamento de produtos e fornecedores com integração MySQL.

## 📋 Pré-requisitos

Antes de executar o projeto, certifique-se de ter instalado:

- **Dart SDK** (versão 3.0.0 ou superior)
- **MySQL** (versão 8.0 ou superior)
- **Git** (para clonar o repositório)

## 🗄️ Configuração do Banco de Dados

### 📥 Obtenha o Script SQL
Para configurar o banco de dados, você precisa do script de criação das tabelas:

**🔗 [CLIQUE AQUI PARA BAIXAR O SCRIPT SQL](https://drive.google.com/drive/folders/1r6_ixbWMwuAvbsFijJkIav_zmQdWtIGw?usp=sharing)**

### 🛠️ Executando o Script

1. **Acesse o MySQL:**
   ```bash
   mysql -u root -p
   ```

2. **Execute o script baixado:**
   ```sql
   source caminho/para/o/script.sql
   ```

3. **Verifique se as tabelas foram criadas:**
   ```sql
   USE sistema_gestao;
   SHOW TABLES;
   ```

## 🚀 Como Executar o Projeto

### 1. 📥 Clone o Repositório
```bash
git clone https://github.com/seu-usuario/sistema-gestao.git
cd sistema-gestao
```

### 2. 📦 Instale as Dependências
```bash
dart pub get
```

### 3. ⚙️ Configure a Conexão com o Banco

Edite o arquivo `bin/main.dart` e atualize as credenciais do MySQL:

```dart
final config = DatabaseConfig(
  host: 'localhost',
  port: 3306,
  user: 'root',
  password: 'sua_senha_aqui', // 🔑 Altere para sua senha
  dbName: 'sistema_gestao',
);
```

### 4. 🎯 No Terminal Execute o Sistema
```bash
dart run .\bin\main.dart
```
# OBS: ANTES DE LISTAR TODOS OS PRODUTOS ATUALIZE O ESTOQUE!!!

## 📊 Funcionalidades do Sistema

### 🏪 Módulo de Produtos
- ✅ Listar todos os produtos
- ✅ Cadastrar novos produtos
- ✅ Buscar produtos por categoria
- ✅ Consultar estoque baixo
- ✅ Atualizar quantidade em estoque

### 🤝 Módulo de Fornecedores
- ✅ Listar todos os fornecedores
- ✅ Cadastrar novos fornecedores
- ✅ Buscar fornecedor por CNPJ
- ✅ Buscar fornecedor por nome

## 🏗️ Arquitetura e Conceitos de POO

### 🔄 Herança
- `Produto` e `Fornecedor` herdam de `EntidadeBase`
- `ProdutoRepositorio` e `FornecedorRepositorio` herdam de `RepositorioBase`

### 🎭 Polimorfismo
- Métodos `toMap()` e `infoBasica` se comportam diferente em cada classe
- Sobrescrita de métodos nas classes filhas

### 🔒 Encapsulamento
- Atributos privados com `_`
- Getters e setters com validações
- Controle de acesso aos dados

### 📐 Abstração
- `EntidadeBase` e `RepositorioBase` são classes abstratas
- Métodos abstratos definem contratos para as classes filhas

## 🗂️ Estrutura do Projeto

```
sistemaprodutos/
├── bin/
│   └── main.dart                 # Ponto de entrada da aplicação
├── lib/
│   ├── database_config.dart      # Configuração do banco
│   ├── database_connection.dart  # Conexão com MySQL
│   ├── entidade_base.dart        # Classe abstrata base
│   ├── produto.dart              # Modelo de Produto
│   ├── fornecedor.dart           # Modelo de Fornecedor
│   ├── repositorio_base.dart     # Repositório abstrato
│   ├── produto_repositorio.dart  # Repositório de produtos
│   ├── fornecedor_repositorio.dart # Repositório de fornecedores
│   └── menu.dart                 # Interface do usuário
└── pubspec.yaml                  # Dependências do projeto
```

## 🐛 Solução de Problemas

### ❌ Erro de Conexão com MySQL
```bash
# Verifique se o MySQL está rodando
sudo service mysql start

# Teste a conexão manualmente
mysql -u root -p -h localhost -P 3306
```

### ❌ Erro "Got packets out of order"
- Verifique a versão do MySQL
- Confirme se as credenciais estão corretas
- Teste com o pacote `mysql_client` como alternativa

### ❌ Dependências não encontradas
```bash
# Limpe e reinstale as dependências
dart pub cache clean
dart pub get
```

## 📈 Dados de Exemplo

O sistema já vem com dados de exemplo incluídos no script SQL:

### 🏷️ Produtos Pré-cadastrados
- Notebook Dell - R$ 2.899,99
- Mouse Logitech - R$ 49,90
- Teclado Mecânico - R$ 299,90
- Monitor Samsung - R$ 899,90
- Smartphone Samsung - R$ 1.599,90

### 🏢 Fornecedores Pré-cadastrados
- TechSupply Brasil
- EletroParts LTDA
- Componentes Express

## 👨‍💻 Desenvolvimento

### Adicionando Novas Funcionalidades

1. **Crie uma nova entidade** herdando de `EntidadeBase`
2. **Implemente o repositório** herdando de `RepositorioBase`
3. **Adicione os métodos** no `Menu`
4. **Atualize a interface** do usuário

### Exemplo de Nova Entidade:
```dart
class Categoria extends EntidadeBase {
  String _nome;
  String _descricao;
  
  // Implementar construtor, getters, setters
  // Sobrescrever toMap() e infoBasica
}
```

