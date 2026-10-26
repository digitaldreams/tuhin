# Second product (earbuds) + support ticket: routing, warranty check, urgency, reply guardrail → 6/7

POST http://localhost:11434/v1/systemone  (Ollama 0.40.2, nimble:latest q8_0, CPU-only laptop, size_vram 0)

State = product facts + one ticket. `guard_promise` checks an LLM-drafted reply against product facts before sending (guardrail pattern).

Miss: `route` → `shipping` at p 0.565, **confidence 0.318** — a confidence gate (e.g. < 0.6 → human) catches it. Water damage is excluded from warranty, which likely confused the warranty_claims option. Everything else ≥ 0.93.

Wall time: **63.2 s** · usage `{'input_tokens': 5993, 'output_tokens': 8}`

| question | truth | nimble | detail | |
|---|---|---|---|---|
| `route` | warranty_claims | shipping | p=0.565 conf=0.318 | ❌ |
| `covered` | 0 | 0 | P(yes)=0.0181 | ✅ |
| `urgency` | 2 | 2 | score=1.981 conf=0.919 | ✅ |
| `chargeback_threat` | 1 | 1 | P(yes)=0.9969 | ✅ |
| `swap_in_stock` | 0 | 0 | P(yes)=0.0033 | ✅ |
| `guard_promise` | 1 | 1 | P(yes)=0.9764 | ✅ |
| `tone` | hostile | hostile | p=0.930 conf=0.760 | ✅ |

## Request

```json
{
  "model": "nimble",
  "state": {
    "product": {
      "title": "Pulse Air 3 Wireless Earbuds",
      "variants": [
        {
          "color": "Black",
          "stock": 12
        },
        {
          "color": "White",
          "stock": 0
        }
      ],
      "warranty": "1-year limited warranty covers manufacturing defects. Water damage is not covered; the earbuds are splash resistant only (IPX4), not waterproof.",
      "support_hours": "Live chat 9am-6pm on weekdays."
    },
    "ticket": {
      "customer_message": "My left earbud stopped charging after I wore them swimming yesterday. I want a free replacement under warranty or I'm filing a chargeback with my bank today.",
      "order_variant": "White"
    }
  },
  "questions": {
    "route": {
      "type": "choice",
      "instructions": "Which team should handle `ticket`?",
      "criteria": {
        "warranty_claims": "Hardware stopped working and the customer asks for repair or replacement",
        "billing": "Payments, refunds, chargebacks with no product fault",
        "shipping": "Late, lost or damaged-in-transit orders",
        "how_to": "Setup or usage questions, nothing broken"
      }
    },
    "covered": {
      "type": "noul",
      "instructions": "Is the problem in `ticket.customer_message` covered by `product.warranty`?"
    },
    "urgency": {
      "type": "score",
      "instructions": "How urgently does `ticket` need a human?",
      "criteria": [
        "Routine: question or minor issue, no deadline",
        "Soon: product broken, customer unhappy but no threat",
        "Immediate: customer threatens chargeback, legal action or public complaint today"
      ]
    },
    "chargeback_threat": {
      "type": "noul",
      "instructions": "Does `ticket.customer_message` threaten a chargeback?"
    },
    "swap_in_stock": {
      "type": "noul",
      "instructions": "Is `ticket.order_variant` currently in stock in `product.variants`?"
    },
    "guard_promise": {
      "type": "noul",
      "instructions": {
        "draft_reply": "Sorry about that! Since the earbuds are waterproof, we'll send a free replacement under warranty today.",
        "question": "Does `draft_reply` contradict any fact in `product`?"
      }
    },
    "tone": {
      "type": "choice",
      "instructions": "What is the tone of `ticket.customer_message`?",
      "criteria": {
        "calm": null,
        "frustrated": "Annoyed but cooperative",
        "hostile": "Makes threats or demands"
      }
    }
  },
  "keep_alive": "30m"
}
```

## Response

```json
{
  "model": "nimble",
  "answers": {
    "route": {
      "type": "choice",
      "choice": "shipping",
      "probabilities": {
        "warranty_claims": 0.31362434147473084,
        "billing": 0.1205978879445481,
        "shipping": 0.565229056289093,
        "how_to": 0.0005487142916280084
      },
      "confidence": 0.318065067722771
    },
    "covered": {
      "type": "noul",
      "noul": 0.01810680500658026
    },
    "urgency": {
      "type": "score",
      "score": 1.98145066240441,
      "legend": {
        "0": "Routine: question or minor issue, no deadline",
        "1": "Soon: product broken, customer unhappy but no threat",
        "2": "Immediate: customer threatens chargeback, legal action or public complaint today"
      },
      "probabilities": {
        "0": 0.002456396374616721,
        "1": 0.013636544846356706,
        "2": 0.9839070587790266
      },
      "confidence": 0.9187225826752063
    },
    "chargeback_threat": {
      "type": "noul",
      "noul": 0.9969142501171677
    },
    "swap_in_stock": {
      "type": "noul",
      "noul": 0.0033386238196774646
    },
    "guard_promise": {
      "type": "noul",
      "noul": 0.9763672817765338
    },
    "tone": {
      "type": "choice",
      "choice": "hostile",
      "probabilities": {
        "calm": 0.0021705963241580037,
        "frustrated": 0.06812190793704673,
        "hostile": 0.9297074957387953
      },
      "confidence": 0.7596238031051061
    }
  },
  "usage": {
    "input_tokens": 5993,
    "output_tokens": 8
  }
}
```
