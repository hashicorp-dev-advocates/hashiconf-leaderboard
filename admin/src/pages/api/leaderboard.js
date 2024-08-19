export default async function createTeam(team) {
    let url = encodeURI(process.env.REACT_APP_LEADERBOARD_API + '/teams');
    let response = await fetch(url, {
        method: "POST",
        body: JSON.stringify(team),
    });
    return await response.json();
}