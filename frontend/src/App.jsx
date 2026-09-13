import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Navbar from "./components/common/Navbar.jsx";
import Hero from "./components/common/Hero.jsx";
import ProductsCard from "./components/common/ProductsCard.jsx";
import Footer from "./components/common/Footer.jsx";
import ProtectedRoute from "./components/common/ProtectedRoute.jsx";
import Dashboard from "./pages/admin/Dashboard.jsx";
function App() {
  return (
    <Router>
      <Navbar />
      <Hero />
      <ProductsCard />
      <Routes>
        <Route
          path="/dashboard"
          element={
            <ProtectedRoute>
              <Dashboard />
            </ProtectedRoute>
          }
        />
      </Routes>
      <Footer />
    </Router>
  );
}
export default App;
