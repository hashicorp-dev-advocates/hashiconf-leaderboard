import { getTeams, deleteTeam } from "./api/leaderboard";
import { useState, useEffect } from 'react';
import DataTable from 'react-data-table-component';

const columns = [
	{
		name: 'ID',
		selector: row => row.id,
    sortable: true,
	},
	{
		name: 'Name',
		selector: row => row.name,
    sortable: true,
	},
	{
		name: 'Activation',
		selector: row => row.activation,
    sortable: true,
	},
	{
		name: 'Time',
		selector: row => row.time,
	},
	{
		name: 'Delete',
    cell: row => (
      <button type="delete" onClick={() => deleteRow(row.id)}>delete</button>
    )
	},
];

async function deleteRow(id) {
  let success = deleteTeam(id);
  if (!success) {
    alert("Did not delete team with id " + id);
  }
  window.location.reload(true);
}

export default function Home() {
  const [teams, setTeams] = useState([]);

  const getData = async () => {
    let data = await getTeams();
    setTeams(data);
  }

  useEffect(() => {
    getData();
   }, []);

  return (
    <>
      <h1>HashiConf Activations Admin Dashboard</h1>
      <DataTable theme="dark" fixedHeader={true} columns={columns} data={teams}></DataTable>
    </>

  )
}