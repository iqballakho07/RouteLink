# RouteLink – Jamshoro to Hyderabad Bus Schedule App

RouteLink is a simple Flutter application that displays bus schedules between Jamshoro and Hyderabad using a REST API. The app demonstrates API integration, state management using setState(), and a clean UI built with Flutter widgets.

---

## Features

- Display list of available bus routes  
- Show departure time for each bus  
- Display fare for each route  
- Show origin to destination  
- Status indicator (On Schedule)  
- Real-time data fetched from API  
- Lightweight and fast UI  

---

## Tech Stack

- Flutter (UI Framework)  
- Dart (Programming Language)  
- HTTP Package (API Integration)  
- REST API (Mock Data)  

---

## API Used

https://mock-api.net/api/JamHydTransit/api/v1/bus-schedule

---

## App Preview

![App Screenshot](https://github.com/iqballakho07/RouteLink/blob/main/RouteLink.jpeg)

---

## Project Structure

lib/
 ├── main.dart        # Entry point  
 ├── models/          # Data models (optional)  
 ├── services/        # API service  
 └── widgets/         # UI components  

---

## How It Works

### API Fetching
- Uses http.get() to retrieve bus schedule data  
- Parses JSON response into Dart objects  

### State Handling (setState)

The app handles three states:

Loading State  
- Displays CircularProgressIndicator while fetching data  

Success State  
- Displays bus routes using ListView.builder  

Error State  
- Shows "Failed to load data" if API fails  

---

## Key UI Components

- AppBar – Displays app title  
- ListView.builder – Renders dynamic list of routes  
- Card – Displays each bus route  
- Row and Column – Layout structure  
- Container – Styling and spacing  

---

## Getting Started

### Clone the Repository

git clone https://github.com/iqballakho07/RouteLink.git  
cd RouteLink  

### Install Dependencies

flutter pub get  

### Run the App

flutter run  

---

## Dependencies

dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.6

---

## Learning Objectives

- REST API integration in Flutter  
- JSON parsing  
- Basic state management using setState()  
- Building responsive UI with ListView  
- Error and loading handling  

---

## Future Improvements

- Search and filter routes  
- Save favorite routes  
- Notifications for schedule updates  
- Map integration  
- Offline caching  

---

## Author

Muhammad Iqbal
Flutter Developer  

---

## License

This project is open-source and available under the MIT License.
