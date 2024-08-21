export default async function createTeam(team) {
    let url = encodeURI(process.env.REACT_APP_LEADERBOARD_API + '/teams');
    try {
        let response = await fetch(url, {
            method: "POST",
            body: JSON.stringify(team),
            headers: new Headers({
                'Authorization': localStorage.getItem('token')
            }),
        });
        if (response.status !== 200) {
            return null
        }
        return await response.json();
    } catch (error) {
        console.log(error);
        return null
    }
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
    try {
        let response = await fetch(url, {
            method: "DELETE",
            headers: new Headers({
                'Authorization': localStorage.getItem('token')
            }),
        });
        if (response.status !== 200) {
            return false
        }
        return true
    } catch (error) {
        console.log(error);
        return false
    }

}

export async function getUser(username, password) {
    let url = encodeURI(process.env.REACT_APP_LEADERBOARD_API + '/login');
    try {
        let response = await fetch(url, {
            headers: new Headers({
                'Authorization': 'Basic ' + btoa(username + ':' + password)
            }),
        });
        if (response.status !== 200) {
            return null
        }
        let auth = await response.json();
        return auth.token
    } catch (error) {
        console.log(error);
        return null
    }
}