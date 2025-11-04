import { useEffect, useState } from 'react'
import './App.css'
import { assertConstantsExist, API_URL } from './constants';

function App() {
  let constantsProblem = assertConstantsExist()
  if (constantsProblem) {
    return <p>
      Error initializing constants: {constantsProblem}
    </p>
  }

  const [data, setData] = useState<any | null>(null);
  const [isLoading, setIsLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      // Reset states before starting
      setError(null);
      setIsLoading(true);

      try {
        const response = await fetch(API_URL);

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const result = await response.json()
        setData(result);

      } catch (e: any) {
        setError(e.message || 'An unknown error occurred');
      } finally {
        // Finally blocks run after try or catch
        setIsLoading(false);
      }
    };

    fetchData();
    // Empty dependency array means "execute once"
  }, []);

  if (isLoading) {
    return <p>Loading data from API...</p>;
  }

  if (error) {
    return <p style={{ color: 'red' }}>Error: {error}</p>;
  }

  return (
    <p>
      {data.hello ? "Hello " + data.hello : JSON.stringify(data)}
    </p>
  );
}

export default App
