// /src/App.tsx

import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import HomePage from './pages/HomePage';
import ProductDetail from './pages/ProductDetail';
import CartPage from './pages/CartPage';
import WishlistPage from './pages/WishlistPage';
import LoginPage from './pages/LoginPage';
import RegisterPage from './pages/RegisterPage';
import ProfilePage from './pages/ProfilePage';
import CheckoutPage from './pages/CheckoutPage';
import OrderConfirmation from './pages/OrderConfirmation';
import OrderHistory from './pages/OrderHistory';
import AddressBook from './pages/AddressBook';
import AdminDashboard from './pages/AdminDashboard';
import ContactPage from './pages/ContactPage';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="/product/:id" element={<ProductDetail />} />
        <Route path="/cart" element={<CartPage />} />
        <Route path="/wishlist" element={<WishlistPage />} />
        <Route path="/login" element={<LoginPage />} />
        <Route path="/register" element={<RegisterPage />} />
        <Route path="/profile" element={<ProfilePage />} />
        <Route path="/checkout" element={<CheckoutPage />} />
        <Route path="/confirmation" element={<OrderConfirmation />} />
        <Route path="/orders" element={<OrderHistory />} />
        <Route path="/addresses" element={<AddressBook />} />
        <Route path="/admin" element={<AdminDashboard />} />
        <Route path="/contact" element={<ContactPage />} />
      </Routes>
    </Router>
  );
}

export default App;

// /src/index.tsx
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './index.css';

const root = ReactDOM.createRoot(document.getElementById('root')!);
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);

// /src/pages/HomePage.tsx
const HomePage = () => {
  return <div>Product Listing Grid Coming Soon...</div>;
};
export default HomePage;

// /src/pages/ProductDetail.tsx
const ProductDetail = () => {
  return <div>Product Detail Page Coming Soon...</div>;
};
export default ProductDetail;

// /src/pages/CartPage.tsx
const CartPage = () => {
  return <div>Shopping Cart Page Coming Soon...</div>;
};
export default CartPage;

// /src/pages/WishlistPage.tsx
const WishlistPage = () => {
  return <div>Wishlist Page Coming Soon...</div>;
};
export default WishlistPage;

// /src/pages/LoginPage.tsx
const LoginPage = () => {
  return <div>Login Page Coming Soon...</div>;
};
export default LoginPage;

// /src/pages/RegisterPage.tsx
const RegisterPage = () => {
  return <div>Register Page Coming Soon...</div>;
};
export default RegisterPage;

// /src/pages/ProfilePage.tsx
const ProfilePage = () => {
  return <div>User Profile Page Coming Soon...</div>;
};
export default ProfilePage;

// /src/pages/CheckoutPage.tsx
const CheckoutPage = () => {
  return <div>Checkout Page Coming Soon...</div>;
};
export default CheckoutPage;

// /src/pages/OrderConfirmation.tsx
const OrderConfirmation = () => {
  return <div>Order Confirmation Page Coming Soon...</div>;
};
export default OrderConfirmation;

// /src/pages/OrderHistory.tsx
const OrderHistory = () => {
  return <div>Order History Page Coming Soon...</div>;
};
export default OrderHistory;

// /src/pages/AddressBook.tsx
const AddressBook = () => {
  return <div>Address Book Page Coming Soon...</div>;
};
export default AddressBook;

// /src/pages/AdminDashboard.tsx
const AdminDashboard = () => {
  return <div>Admin Panel Coming Soon...</div>;
};
export default AdminDashboard;

// /src/pages/ContactPage.tsx
const ContactPage = () => {
  return <div>Contact Form Coming Soon...</div>;
};
export default ContactPage;
