import React, { useEffect, useState } from "react";
import { BrowserRouter, Routes, Route, Navigate, useNavigate } from "react-router-dom";

import SkillsList from "./components/SkillsList";
import SignupForm from "./components/SignupForm";
import LoginForm from "./components/LoginForm";
import MatchesList from "./components/MatchesList";

import "./App.css";

/* -----------------------------
   Layout wrapper (keeps old CSS)
------------------------------ */
function AppLayout({ isLoggedIn, user, onLogout }) {
  const navigate = useNavigate();

  return (
    <div className="App">
      <header className="app-header">
        <div className="header-content">
          <div>
            <h1>Skill Swap</h1>
            <p>Exchange skills with your community</p>
          </div>

          <div className="nav-bar">
            <button className="logout-btn" onClick={() => navigate("/skills")} >Skills</button>
            <button className="logout-btn"onClick={() => navigate("/matches")}>Matches</button>
          </div>

          <button className="logout-btn" onClick={onLogout}>
            Sign Out
          </button>
        </div>
      </header>

      <main>
        <Routes>
          <Route path="/skills" element={<SkillsList />} />
          <Route path="/matches" element={<MatchesList user={user} />} />
          <Route path="*" element={<Navigate to="/skills" />} />
        </Routes>
      </main>
    </div>
  );
}

/* -----------------------------
   Main App
------------------------------ */
export default function App() {
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [user, setUser] = useState(null);

  useEffect(() => {
    const token = localStorage.getItem("authToken");
    const savedUser = localStorage.getItem("user");

    if (token && savedUser) {
      setIsLoggedIn(true);
      setUser(JSON.parse(savedUser));
    }
  }, []);

  const handleLoginSuccess = () => {
    const savedUser = localStorage.getItem("user");
    if (savedUser) {
      setUser(JSON.parse(savedUser));
      setIsLoggedIn(true);
    }
  };

  const handleLogout = () => {
    localStorage.removeItem("authToken");
    localStorage.removeItem("user");
    setIsLoggedIn(false);
    setUser(null);
  };

  return (
    <BrowserRouter>
      <Routes>
        {/* LOGIN = HOME */}
        <Route
          path="/"
          element={
            isLoggedIn ? (
              <Navigate to="/skills" />
            ) : (
              <LoginForm onLoginSuccess={handleLoginSuccess} />
            )
          }
        />

        <Route
          path="/signup"
          element={<SignupForm onLoginSuccess={handleLoginSuccess} />}
        />

        {/* PROTECTED AREA */}
        <Route
          path="/*"
          element={
            isLoggedIn ? (
              <AppLayout
                isLoggedIn={isLoggedIn}
                user={user}
                onLogout={handleLogout}
              />
            ) : (
              <Navigate to="/" />
            )
          }
        />
      </Routes>
    </BrowserRouter>
  );
}
