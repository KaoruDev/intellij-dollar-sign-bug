package com.example.playground

// This compile just fine even though Intellij does not index the file properly
import com.example.finagle.FooService$FinagleClient

object Runner extends App {
  println("Ok I'm runninger!")

  // This compile just fine even though Intellij does not index the file properly
  val client = new com.example.finagle.FooService$FinagleClient(null, null)
}

