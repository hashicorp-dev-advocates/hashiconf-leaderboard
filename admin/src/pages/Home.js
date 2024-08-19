import { Link } from 'react-router-dom';

export default function Home() {
  return (
    <>
      <h1>HashiConf Activations Admin Dashboard</h1>
      <body><div class="container"><button><Link to="/delete">Need to delete a team?</Link></button></div></body>
    </>
  )
}