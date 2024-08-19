import { useForm } from "react-hook-form"
import createTeam from "./api/leaderboard"

const activation = "robots";

export default function Robots() {
  const {
    register,
    handleSubmit,
    formState: { errors }
  } = useForm();

  const onSubmit = async data => {
    data = { activation, ...data }
    let response = await createTeam(data);
    if (response.id != null) {
      alert("Created team with ID " + response.id)
    } else {
      alert("Error: could not create team")
    }
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <h1>Robots</h1>
      <label>Team Name</label>
      <input
        {...register("name", {
          required: true,
          maxLength: 65,
        })}
      />
      {errors?.name?.type === "required" && <p>This field is required</p>}
      {errors?.name?.type === "maxLength" && (
        <p>Team name cannot exceed 65 characters</p>
      )}
      <label>Time in seconds</label>a
      <input type="number" {...register("time", { required: true, min: 1, max: 1200, valueAsNumber: true })} />
      {errors.time && (
        <p>Time must be in seconds and less than 20 minutes (1200 seconds)</p>
      )}
      <input type="submit" />
    </form>
  );
}