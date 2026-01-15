import SkillsList from "./components/SkillsList";
import "./App.css";

function App() {
  return (
    <div className="App">
      <header className="app-header">
        <h1>Skill Swap</h1>
        <p>Exchange skills with your community</p>
      </header>
      <main>
        <SkillsList />
      </main>
    </div>
  );
}

export default App;