import { BrowserRouter, Routes, Route } from "react-router-dom";
import EscapeRoom from "./pages/EscapeRoom";
import Robots from "./pages/Robots";
import Home from "./pages/Home";
import Delete from "./pages/Delete";
import Navbar from "./components/Navbar";

export default function App() {
  return (
    <BrowserRouter>
      <Navbar />
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="escape-room" element={<EscapeRoom />} />
        <Route path="robots" element={<Robots />} />
        <Route path="delete" element={<Delete />} />
      </Routes>
    </BrowserRouter>
  );
}