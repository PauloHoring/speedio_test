# SpeedIO Test

O objetivo é criar uma API Rails integrada com MongoDB para automatizar mensagens no LinkedIn e por email usando a API da Unipile.

## Tecnologias

- Ruby on Rails 5.2.8.1
- MongoDB 7.0.5

## Configuração do projeto

* **Instalação:**

  * Para obter uma cópia da aplicação, utilize o seguinte comando:

    ```bash
    git clone https://github.com/PauloHoring/speedio_test.git
    ```

  * Uma vez no diretório do projeto clonado, execute o seguinte comando no terminal:

    ```bash
    bundle install
    ```

  * Inicie o seu MongoDB e Redis da maneira que está configurado no seu ambiente. Seja por docker container ou instalação local.

  * Configure as variáveis de ambiente em um arquivo .env na raíz do projeto:
    ```bash
    UNIPILE_API_KEY # Seu token gerado na Unipile (https://dashboard.unipile.com/access-tokens)
    UNIPILE_API_URL # Seu DSN gerado na Unipíle (https://dashboard.unipile.com/accounts)
    ```

  * Por último, para iniciar o projeto, execute o seguinte comando no terminal:
    ```bash
    rails s
    ```

## Rotas (Siga a sequência até a parte de configuração dos IDs)
* **Registrar o usuário**

    * **URL:**

      ```bash
      POST /api/v1/register
      ```

    * **Body:**

      ```json
      {
        "user": {
          "name": "<NOME DO USUÁRIO>",
          "email": "<EMAIL>"
        }
      }
      ```

* **Logar o usuário**

    * **URL:**

      ```bash
      POST /api/v1/login
      ```

    * **Body:**

      ```json
      {
        "email": "<EMAIL>",
      }
      ```

* **Autenticação do usuário**

    * **URL:**

      ```bash
      POST /api/v1/auth
      ```

    * **Body:**

      ```json
      {
        "email": "<EMAIL>",
        "otp": "<OTP>" //Código de 6 dígitos gerado no login
      }
      ```

* **Autenticação de contas que serão usadas na Unipile**

    * **URL:**

      ```bash
      POST /api/v1/automations/requestconfigurationlink
      ```

    * **Headers:**

      ```json
      {
        "Authorization": "<Bearer TOKEN>" //Token de autorização gerado anteriormente
      }
      ```

    * **Body:**

      ```json
      {}
      ```

* **Configuração de conta**

    * **URL:**

      ```bash
      POST /api/v1/config
      ```

    * **Headers:**

      ```json
      {
        "Authorization": "<Bearer TOKEN>" //Token de autorização gerado anteriormente
      }
      ```

    * **Body:**

      ```json
      {
        "unipile_email_account_id": "<ACCOUNT_ID>", //ID único do gmail gerado após autenticar na Unipile
        "unipile_linkedin_account_id": "<ACCOUNT_ID>" //ID único do linkedin gerado após autenticar na Unipile
      }
      ```

* **Programar envio de email**

    * **URL:**

      ```bash
      POST /api/v1/companies/sendmail
      ```

    * **Headers:**

      ```json
      {
        "Authorization": "<Bearer TOKEN>" //Token de autorização gerado anteriormente
      }
      ```

    * **Body:**

      ```json
      {
        "email": {
          "message": "<MENSAGEM A SER ENVIADA>",
          "to": "<DESTINATÁRIO>",
          "programmed_to": "<HORÁRIO PROGRAMADO PARA ENVIO DO EMAIL>" //Formato: dia-mês-ano hora-minuto (Exemplo: 01-01-0001 01:01)
        }
      }
      ```

* **Programar envio de conexão**

    * **URL:**

      ```bash
      POST /api/v1/companies/sendinvite
      ```

    * **Headers:**

      ```json
      {
        "Authorization": "<Bearer TOKEN>" //Token de autorização gerado anteriormente
      }
      ```

    * **Body:**

      ```json
      {
        "invite": {
          "profile_url": "<URL>", //URL do perfil que você quer conectar (Exemplo: linkedin.com/in/usuário/)
          "programmed_to": "<HORÁRIO PROGRAMADO PARA ENVIO DA CONEXÃO>" //Formato: dia-mês-ano hora-minuto (Exemplo: 01-01-0001 01:01)
        }
      }
      ```

* **Programar envio de mensagem no linkedin**

    * **URL:**

      ```bash
      POST /api/v1/companies/sendmessage
      ```

    * **Headers:**

      ```json
      {
        "Authorization": "<Bearer TOKEN>" //Token de autorização gerado anteriormente
      }
      ```

    * **Body:**

      ```json
      {
        "message": {
          "message": "<MENSAGEM A SER ENVIADA>",
          "profile_url": "<URL>", //URL do perfil que você quer enviar mensagem (Exemplo: linkedin.com/in/usuário/)
          "programmed_to": "<HORÁRIO PROGRAMADO PARA ENVIO DA MENSAGEM>" //Formato: dia-mês-ano hora-minuto (Exemplo: 01-01-0001 01:01)
        }
      }
      ```