<div align="center">
  <!-- Logo Placeholder -->
  <img src="https://via.placeholder.com/150x150?text=ExpenseEase+Logo" alt="ExpenseEase Logo" width="150" />

  <h1>ExpenseEase</h1>
  
  <p>
    <b>A Modern, Cross-Platform Personal Financial Tracking Application</b>
  </p>
</div>

---

## 📖 Project Overview
ExpenseEase is a comprehensive mobile application meticulously engineered to simplify personal financial management. Built adhering to clean architecture principles, it empowers users to record incomes and expenses securely, analyze spending patterns interactively, and maintain absolute control over their financial health through a highly intuitive and minimalist user interface.

## ✨ Key Features
* **Firebase Authentication**: Secure user registration, identity verification, and personalized session management.
* **Real-time Cloud Firestore**: Seamless, instant synchronization of all financial transactions across devices utilizing WebSockets.
* **Multi-Currency Support**: Dynamic global localization allowing users to seamlessly toggle between US Dollar ($), Euro (€), and Turkish Lira (₺) across the entire application interface.
* **Interactive Data Visualization**: Integration of the `fl_chart` library to render responsive, highly precise pie charts for expenditure distribution analysis.
* **Advanced Data Filtering**: Robust querying algorithms enabling historical data retrieval via custom native date pickers or predefined rolling timeframes (Last 7 days, 30 days, 3 months).

## 🏗️ Technical Architecture
The application relies on a strictly decoupled software architecture to ensure scalability:
* **Flutter Framework**: Utilized for its highly performant, cross-platform capabilities, compiling natively to iOS, Android, and Web environments from a single Dart codebase.
* **Provider State Management**: The `ChangeNotifier` pattern serves as the reactive bridge between backend data streams and the declarative UI, ensuring accurate and efficient recalculation of financial aggregates without manual refreshing.
* **Firebase Backend-as-a-Service (BaaS)**: Abstracts server-side complexities, providing hardened security rules (`request.auth.uid == resource.data.uid`) and robust, scalable NoSQL document structuring.

## 🚀 How to Install & Run

1. **Clone the repository:**
   ```bash
   git clone <repository_url>
   cd expenses
   ```
2. **Install Flutter Dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run the Application:**
   Ensure you have a simulator running, a physical device connected, or execute directly on Google Chrome.
   ```bash
   flutter run -d chrome
   ```

## 👨‍💻 About Developer
**Ahmet Haithem**  
This application was engineered and submitted as a comprehensive university project demonstrating applied computer science principles in cross-platform mobile development, secure cloud integration, and user-centric software design.

## 📱 Screenshots

<table>
  <tr>
    <td align="center">
      <img src="https://via.placeholder.com/200x400?text=Onboarding" alt="Onboarding Screen" width="200"/><br>
      <b>Onboarding</b>
    </td>
    <td align="center">
      <img src="https://via.placeholder.com/200x400?text=Login" alt="Login Screen" width="200"/><br>
      <b>Login Flow</b>
    </td>
    <td align="center">
      <img src="https://via.placeholder.com/200x400?text=Dashboard" alt="Dashboard" width="200"/><br>
      <b>Personal Dashboard</b>
    </td>
    <td align="center">
      <img src="https://via.placeholder.com/200x400?text=Stats+Chart" alt="Statistics Chart" width="200"/><br>
      <b>Statistics & Charts</b>
    </td>
  </tr>
</table>
