import { BrowserRouter, Routes, Route } from "react-router-dom";
import EscapeRoom from "./pages/EscapeRoom";
import Robots from "./pages/Robots";
import Home from "./pages/Home";
import Delete from "./pages/Delete";
import Navbar from "./components/Navbar";
import Login from "./pages/Login";
import { AuthProvider } from "./hooks/useAuth";
import { ProtectedRoute } from "./components/ProtectedRoute";

export default function App() {
  return (
    <BrowserRouter>
      <Navbar />
      <AuthProvider>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="login" element={<ProtectedRoute><Login /></ProtectedRoute>} />
        <Route path="escape-room" element={<ProtectedRoute><EscapeRoom /></ProtectedRoute>} />
        <Route path="robots" element={<ProtectedRoute><Robots /></ProtectedRoute>} />
        <Route path="delete" element={<ProtectedRoute><Delete /></ProtectedRoute>} />
      </Routes>
      </AuthProvider>
    </BrowserRouter>
  );
}