import { useEffect, useState } from "react";

function App() {
  const [status, setStatus] = useState("Checking backend...");
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch("http://127.0.0.1:3000/up")
      .then((response) => {
        if (!response.ok) {
          throw new Error("Backend is down");
        }
        return response.text(); // 👈 IMPORTANT (HTML, not JSON)
      })
      .then(() => {
        setStatus("✅ Backend is UP");
      })
      .catch((err) => {
        console.error(err);
        setError("❌ Failed to connect to backend");
      });
  }, []);

  return (
    <div style={{ padding: "2rem", fontFamily: "Arial" }}>
      <h1>SkillSwap Frontend</h1>

      {error ? (
        <p style={{ color: "red" }}>{error}</p>
      ) : (
        <p>{status}</p>
      )}
    </div>
  );
}

export default App;
