import { useState, useEffect } from "react";
import SkillsList from "./components/SkillsList";
import SignupForm from "./components/SignupForm";
import LoginForm from "./components/LoginForm";
import "./App.css";

function App() {
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [currentPage, setCurrentPage] = useState("signup");
  const [user, setUser] = useState(null);

  useEffect(() => {
    const token = localStorage.getItem("authToken");
    const savedUser = localStorage.getItem("user");
    
    if (token && savedUser) {
      setIsLoggedIn(true);
      setUser(JSON.parse(savedUser));
      setCurrentPage("home");
    }
  }, []);

  const handleLoginSuccess = () => {
    const token = localStorage.getItem("authToken");
    const savedUser = localStorage.getItem("user");
    
    if (token && savedUser) {
      setIsLoggedIn(true);
      setUser(JSON.parse(savedUser));
      setCurrentPage("home");
    }
  };

  const handleLogout = () => {
    localStorage.removeItem("authToken");
    localStorage.removeItem("user");
    setIsLoggedIn(false);
    setUser(null);
    setCurrentPage("signup");
  };

  return (
    <div className="App">
      {isLoggedIn && currentPage === "home" ? (
        <>
          <header className="app-header">
            <div className="header-content">
              <div>
                <h1>Skill Swap</h1>
                <p>Exchange skills with your community</p>
              </div>
              <button className="logout-btn" onClick={handleLogout}>
                Sign Out
              </button>
            </div>
          </header>
          <main>
            <SkillsList />
          </main>
        </>
      ) : currentPage === "signup" ? (
        <SignupForm onLoginSuccess={handleLoginSuccess} setCurrentPage={setCurrentPage} />
      ) : (
        <LoginForm onLoginSuccess={handleLoginSuccess} setCurrentPage={setCurrentPage} />
      )}
    </div>
  );
}

export default App;