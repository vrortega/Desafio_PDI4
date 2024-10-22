<div align="center"><h1>PDI 4 🛬</div></h1>

## ✈️ Introdução
Este projeto é uma aplicação de agendamento de voos desenvolvida usando a arquitetura MVVM (Model-View-ViewModel) em Swift. A aplicação permite criar, visualizar e gerenciar voos, passageiros e tripulação, utilizando uma interface simples.


## 📁 Estrutura do projeto
O projeto segue a arquitetura MVVM, dividindo a lógica da aplicação em três principais componentes:

<li>Model: Representa as entidades e dados do aplicativo, como Flight, Passenger, Pilot, etc.</li>
<li>ViewModel: Faz a intermediação entre a View e o Model, processando os dados e aplicando regras de negócios.</li>
<li>View: Composta pelas ViewControllers que exibem os dados processados pelo ViewModel e gerenciam as interações do usuário.</li>

## 🎯 Finalidade do Projeto
A finalidade deste projeto é fornecer uma ferramenta prática para o gerenciamento de voos. Ele permite:

- <b>Adicionar Voos:</b> Criação de novos voos especificando cidades de origem e destino, datas de ida e volta, capacidade e tripulação.
- <b>Gerenciar Passageiros:</b> Adicionar, visualizar e remover passageiros, garantindo que todos sejam adultos.
- <b>Gerenciar Tripulação:</b> Adicionar, visualizar e remover membros da tripulação, incluindo pilotos, co-pilotos e comissários de bordo.
- <b>Clima em Tempo Real:</b> O app consulta uma API de clima para mostrar as condições meteorológicas da localização atual do dispositivo.
- <b>Visualizar Detalhes dos Voos:</b> Exibir todas as informações relevantes sobre um voo específico, incluindo passageiros e tripulação.
- <b>Interface Programática:</b> Toda a interface do usuário foi desenvolvida sem o uso de Storyboards, utilizando UIKit programaticamente.

## 🚀 Como Rodar

### Clone o repositório:

```sh
git clone https://github.com/vrortega/Desafio_PDI4
cd Desafio_PDI4
```

* **Abra o Projeto no Xcode:**

Navegue até o arquivo `Desafio_PDI4.xcodeproj` e abra-o com o Xcode.

* **Instale as Dependências:**

Se o projeto utilizar CocoaPods, execute `pod install` para instalar as dependências necessárias.

* **Configure a API de Clima**

Substitua a chave da API de clima (apiKey) no arquivo FlightsViewController.swift com a sua própria chave da <a href="https://www.weatherapi.com/docs/">WeatherAPI</a>.

* **Compile e Rode o Projeto:**

Pressione `Cmd + R` ou clique no botão de rodar no Xcode.
