export default async function createTeam(team) {
    let url = encodeURI(process.env.REACT_APP_LEADERBOARD_API + '/teams');
    let response = await fetch(url, {
        method: "POST",
        body: JSON.stringify(team),
    });
    return await response.json();
}

export async function getTeams() {
    let url = encodeURI(process.env.REACT_APP_LEADERBOARD_API + '/teams');
    try {
        let response = await fetch(url);
        return await response.json();
    } catch (error) {
        console.log(error);
        return [];
    }
}

export async function deleteTeam(team) {
    let url = encodeURI(process.env.REACT_APP_LEADERBOARD_API + '/teams/' + team);
    let response = await fetch(url, {
        method: "DELETE",
    });
    if (response.status !== 200) {
        return false
    }
    return true
}

export async function getUser(username, password) {
    let url = encodeURI(process.env.REACT_APP_LEADERBOARD_API + '/login');
    let response = await fetch(url, {
        headers: new Headers({
            'Authorization': 'Basic ' + btoa(username + ':' + password)
        }),
    });
    if (response.status !== 200) {
        return false
    }
    return true
}