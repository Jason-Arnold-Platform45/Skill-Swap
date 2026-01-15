import { useState, useEffect } from "react";
import SkillsList from "./components/SkillsList";
import SignupForm from "./components/SignupForm";
import LoginForm from "./components/LoginForm";
import MatchesList from "./components/MatchesList";

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
      {isLoggedIn ? (
        <>
          <header className="app-header">
            <div className="header-content">
              <div>
                <h1>Skill Swap</h1>
                <p>Exchange skills with your community</p>
              </div>

              <div className="nav-bar">
                <button onClick={() => setCurrentPage("home")}>
                  Skills
                </button>
                <button onClick={() => setCurrentPage("matches")}>
                  Matches
                </button>
              </div>
              <button className="logout-btn" onClick={handleLogout}>
                  Sign Out
                </button>
            </div>
          </header>

          <main>
            {currentPage === "home" && <SkillsList />}
            {currentPage === "matches" && <MatchesList user={user} />}
          </main>
        </>
      ) : currentPage === "signup" ? (
        <SignupForm
          onLoginSuccess={handleLoginSuccess}
          setCurrentPage={setCurrentPage}
        />
      ) : (
        <LoginForm
          onLoginSuccess={handleLoginSuccess}
          setCurrentPage={setCurrentPage}
        />
      )}
    </div>
  );
}

export default App;