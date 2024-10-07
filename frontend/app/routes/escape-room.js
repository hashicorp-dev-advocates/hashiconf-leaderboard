import Route from '@ember/routing/route';
import { hash } from 'rsvp';
import GetTeams from './leaderboard-api';

export default class EscapeRoomRoute extends Route {
  async model() {
    return hash({
      ilm: GetTeams("ilm"),
      slm: GetTeams("slm")
    });
  }
}