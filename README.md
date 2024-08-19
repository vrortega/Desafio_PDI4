<div align="center"><h1>PDI 3 🛬</div></h1>

## ✈️ Introdução
Este projeto é um aplicativo de gerenciamento de voos que permite aos usuários cadastrar passageiros, tripulantes e adicionar voos. O app possui integração com uma API de clima, que verifica automaticamente as condições meteorológicas do local atual do dispositivo. O app foi desenvolvido em **UIKit**, sem o uso de Storyboards, com todos os elementos criados programaticamente.


## 📁 Estrutura das Pastas
```css
├── 📁 Controllers
│   ├── 📄 FlightsViewController.swift
│   ├── 📄 NewFlightViewController.swift
│   ├── 📄 FlightDetailsViewController.swift
│   ├── 📄 CrewViewController.swift
│   └── 📄 PassengersViewController.swift
├── 📁 Models
│   ├── 📄 Passenger.swift
│   ├── 📄 Pilot.swift
│   ├── 📄 FlightAttendant.swift
│   ├── 📄 Flight.swift
│   └── 📄 WeatherResponse.swift
└── 📄 AppDelegate.swift
└── 📄 SceneDelegate.swift
```

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
git clone https://github.com/vrortega/Desafio_PDI3.git
cd Desafio_PDI3
```

* **Abra o Projeto no Xcode:**

Navegue até o arquivo `Desafio_PDI3.xcodeproj` e abra-o com o Xcode.

* **Instale as Dependências:**

Se o projeto utilizar CocoaPods, execute `pod install` para instalar as dependências necessárias.

* **Configure a API de Clima**

Substitua a chave da API de clima (apiKey) no arquivo FlightsViewController.swift com a sua própria chave da <a href="https://www.weatherapi.com/docs/">WeatherAPI</a>.

* **Compile e Rode o Projeto:**

Pressione `Cmd + R` ou clique no botão de rodar no Xcode.
