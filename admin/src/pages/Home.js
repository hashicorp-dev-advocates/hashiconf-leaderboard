import { useState } from "react";
import { useAuth } from "../hooks/useAuth";
import { useForm } from "react-hook-form"
import { getUser } from "./api/leaderboard";

export default function Home() {
  const {
    register,
    handleSubmit,
    formState: { errors },
    reset,
  } = useForm();
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const { login } = useAuth();

  const onSubmit = async (e) => {
    let success = await getUser(username, password);
    if (success) {
      await login({ username, password });
      reset();
    } else {
      alert("Invalid username or password");
    }
  };

  return (
    <>
      <h1>HashiConf Activations Admin Dashboard</h1>
      <div>
        <form onSubmit={handleSubmit(onSubmit)}>
          <label>Username</label>
          <input
            {...register("username", {
              required: true,
              maxLength: 65,
              onChange: (e) => setUsername(e.target.value)
            })}
          />
          {errors?.username?.type === "required" && <p>This field is required</p>}
          <label>Password</label>
          <input
            type="password"
            {...register("password", {
              required: true,
              onChange: (e) => setPassword(e.target.value)
            })}
          />
          {errors?.username?.type === "required" && <p>This field is required</p>}
          <input type="submit" />
        </form>
      </div>
    </>
  )
}